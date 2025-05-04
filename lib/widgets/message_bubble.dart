import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 55, 180, 230),
            borderRadius: BorderRadius.circular(12),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        )
      ],
    );
  }
}
