import 'package:chat/models/auth_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _currentUser;

  AuthService() {
    // Escuta as mudanças no estado de autenticação do Firebase
    _firebaseAuth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
      print('AuthService: User changed to: ${_currentUser?.uid ?? 'null'}');
    });
  }

  User? get currentUser => _currentUser;

  //------ SIGN IN -----
  Future<void> signIn(AuthData authData) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: authData.email!, password: authData.password!);
  }

  //----- NEW USERS ----
  Future<void> registerNewUser(AuthData authData) async {
    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
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

  // --- LOG OFF ---
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
