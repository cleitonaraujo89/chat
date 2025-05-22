// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.message,
      required this.userName,
      required this.userImage,
      required this.belongstoMe,
      Key? key})
      : super(key: key);

  final String message;
  final String userName;
  final String userImage;
  final bool belongstoMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              belongstoMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: belongstoMe
                    ? Color.fromARGB(255, 45, 200, 135)
                    : const Color.fromARGB(255, 55, 180, 230),
                borderRadius: BorderRadius.only(
                  topLeft:
                      belongstoMe ? Radius.circular(12) : Radius.circular(26),
                  topRight:
                      belongstoMe ? Radius.circular(26) : Radius.circular(12),
                  bottomLeft:
                      belongstoMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight:
                      belongstoMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment: belongstoMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    textAlign: belongstoMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: 0,
          left: belongstoMe ? null : 130,
          right: belongstoMe ? 130 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
