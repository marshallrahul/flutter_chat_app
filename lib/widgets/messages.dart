import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = snapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: document.length,
              itemBuilder: (ctx, index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: document[index].data()['userId'] ==
                          FirebaseAuth.instance.currentUser.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    MessageBubble(
                      document[index].data()['text'],
                      document[index].data()['userId'],
                      document[index].data()['userimage'],
                      document[index].data()['username'],
                      document[index].data()['userId'] ==
                          FirebaseAuth.instance.currentUser.uid,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
