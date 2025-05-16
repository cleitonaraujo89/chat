// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../utils/auth_error_messages.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _tooManyRequests = false;
  int _secondsRemaining = 0;
  Timer? _lockoutTimer;

  Future<void> _handleSubmit(AuthData authData) async {
    if (authData.email == null || authData.password == null) return;

    setState(() {
      _isLoading = true;
    });

    UserCredential userCredential;
    try {
      if (authData.isLogin) {
        userCredential = await _fireBaseAuth.signInWithEmailAndPassword(
          email: authData.email!,
          password: authData.password!,
        );
      } else {
        userCredential = await _fireBaseAuth.createUserWithEmailAndPassword(
          email: authData.email!,
          password: authData.password!,
        );

        if (userCredential.user == null) return;

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.img');

        await ref.putFile(authData.image!);
        final urlBucket = await ref.getDownloadURL();

        final registredUser = {
          'name': authData.name,
          'email': authData.email,
          'imageUrl': urlBucket,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(registredUser);
      }
    } on FirebaseAuthException catch (e) {
      //verifica se o widget ta montado para evitar erros
      if (!mounted) return;

      bool tooManyRequests = handleAuthError(context, e.code);
      if (tooManyRequests) _startLockoutCountdown();
    } catch (err) {
      if (!mounted) return;
      handleAuthError(context, 'undefined');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startLockoutCountdown() {
    // se já estiver num bloqueio, não reinicia
    if (_tooManyRequests) return;

    setState(() {
      _tooManyRequests = true;
      _secondsRemaining = 180; // 3 minutos em segundos
    });

    _lockoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _tooManyRequests = false;
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // body: AuthForm(onSubmit: _handleSubmit),
      body: Stack(
        children: [
          AuthForm(
            onSubmit: _handleSubmit,
            isLockedOut: _tooManyRequests,
            lockoutSeconds: _secondsRemaining,
          ),
          if (_isLoading)
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}
