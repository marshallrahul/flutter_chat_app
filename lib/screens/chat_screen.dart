import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  var _enteredText = '';

  Future<void> _sendMessage() async {
    User user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chats').add({
      'createdAt': Timestamp.now(),
      'text': _messageController.text,
      'userId': user.uid,
      'username': userData['username'],
      'userimage': userData['url']
    });
    _messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.exit_to_app),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemValue) {
              if (itemValue == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Messages(),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 5.0,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Send a message...',
                        fillColor: Theme.of(context).accentColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _messageController,
                      onChanged: (value) {
                        _enteredText = value;
                        // print(value);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).accentColor,
                  onPressed: _enteredText.trim().isEmpty ? null : _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
