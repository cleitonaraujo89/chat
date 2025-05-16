// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.user});

  final User user;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final enteredText = _messageController.text.trim();

    if (enteredText.isEmpty) return;

    FocusScope.of(context).unfocus();

    try {
      String userId = widget.user.uid;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userId.isEmpty) return;

      if (!userData.exists ||
          userData.data() == null ||
          userData.data()!.isEmpty) return;

      FirebaseFirestore.instance.collection('chat').add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'userName': userData['name'],
        'userImage': userData['imageUrl'],
      });
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar mensagem. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Enviar Mensagem...'),
              controller: _messageController,
              //primeira letra maiúscula
              textCapitalization: TextCapitalization.sentences,
              //altera o Enter para 'Enviar'
              textInputAction: TextInputAction.send,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          IconButton(
              onPressed:
                  _messageController.text.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
