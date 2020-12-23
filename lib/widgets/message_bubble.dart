import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String userId;
  final String image;
  final String username;
  final bool isMe;

  MessageBubble(
    this.text,
    this.userId,
    this.image,
    this.username,
    this.isMe,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                ),
                softWrap: true,
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: userId == FirebaseAuth.instance.currentUser.uid
                ? Colors.blue[100]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Positioned(
          top: -5.0,
          left: isMe ? 0 : null,
          right: !isMe ? 0 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 15.0,
          ),
        ),
      ],
    );
  }
}
