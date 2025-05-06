// ignore_for_file: prefer_const_constructors

import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    //faz o monitoramento constante se há mudanças no DB
    return StreamBuilder(
      //O Snapshot vai ordenado de acordo com a data de envio de modo decrescente
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      //o que é recebido é atribuido ao segundo parametro (snapshot)
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (chatSnapshot.hasError) {
          return Center(child: Text('Ocorreu um erro!'));
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma mensagem ainda.'));
        }

        //pegamos o valor recebido e trabalhamos ele abaixo
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            message: chatDocs[i]['text'],
            belongstoMe: chatDocs[i]['userId'] == user.uid,
            key: ValueKey(chatDocs[i].id),
          ),
        );
      },
    );
  }
}
