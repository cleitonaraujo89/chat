// ignore_for_file: prefer_const_constructors

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/auth_error_messages.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;

  Future<void> _handleSubmit(AuthData authData) async {
    if (authData.email == null || authData.password == null) return;

    try {
      if (authData.isLogin) {
        await _fireBaseAuth.signInWithEmailAndPassword(
          email: authData.email!,
          password: authData.password!,
        );
      } else {
        await _fireBaseAuth.createUserWithEmailAndPassword(
          email: authData.email!,
          password: authData.password!,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);

      //verifica se o wodget ta montado para evitar erros
      if (!mounted) return;

      handleAuthError(context, e.code);
    } catch (err) {
      if (!mounted) return;
      handleAuthError(context, 'undefined');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(onSubmit: _handleSubmit),
    );
  }
}
