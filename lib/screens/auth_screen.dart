import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void submitFn(
    String email,
    String username,
    String password,
    bool isLogin,
    File image,
  ) async {
    UserCredential userCredential;
    if (!isLogin) {
      try {
        userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user.uid + '.jpg');
        await firebaseStorageRef.putFile(image);
        final url = await firebaseStorageRef.getDownloadURL();
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection('users');
        collectionReference.doc(userCredential.user.uid).set({
          'username': username,
          'email': email,
          'url': url,
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AuthForm(submitFn),
            ),
          ),
        ),
      ),
    );
  }
}
