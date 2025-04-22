// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //faz o monitoramento constante se há mudanças no DB
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        //o que é recebido é atribuido ao segundo parametro (snapshot)
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          //pegamos o valor recebido e trabalhamos ele abaixo
          final documents = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, i) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[i]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance.collection('chat').add({
            'text': 'Adicionado pelo app',
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
