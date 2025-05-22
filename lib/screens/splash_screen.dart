// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.user});

  final User user;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final query = await FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    final docs = query.docs;

    for (final doc in docs) {
      final imageUrl = doc['userImage'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty && mounted) {
        // essa chamada vai baixar e armazenar em cache
        await precacheImage(NetworkImage(imageUrl), context);
      }
    }

    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset('assets/images/animacao_chat.json'),
            Positioned(
              top: screenHeight * 0.3,
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.5,
                child: Lottie.asset('assets/images/animacao_loading2.json'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
