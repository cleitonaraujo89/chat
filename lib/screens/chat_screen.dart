// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => Container(
          padding: EdgeInsets.all(10),
          child: Text('Funcionou!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chat')
              .snapshots()
              .listen((querySnapshot) {
            querySnapshot.docs.forEach((element) {
              print(element['text']);
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
