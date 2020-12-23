import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
  AuthForm(this.submitFn);

  final void Function(
    String email,
    String username,
    String password,
    bool signup,
    File image,
  ) submitFn;
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  User user = FirebaseAuth.instance.currentUser;

  var _email = '';
  var _username = '';
  var _password = '';
  bool signup = false;
  File _userImageFile;

  @override
  void dispose() {
    super.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _saveAuthForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    FocusScope.of(context).unfocus();
    widget.submitFn(_email.trim(), _username.trim(), _password.trim(), signup,
        _userImageFile);
  }

  void _getImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (signup) UserImagePicker(_getImage),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email address'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: false,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(
                  signup ? _usernameFocusNode : _passwordFocusNode,
                );
              },
              validator: (value) {
                if (!value.contains('@') ||
                    !value.contains('.com') ||
                    value.isEmpty) {
                  return 'Please provide a valid email id';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            if (signup)
              TextFormField(
                focusNode: _usernameFocusNode,
                decoration: InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: true,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(15),
                ],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onSaved: (value) {
                  _username = value;
                },
              ),
            TextFormField(
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(labelText: 'Password'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              obscureText: true,
              enableSuggestions: false,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(20),
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide password';
                }
                if (value.length <= 6) {
                  return 'password is too small';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: _saveAuthForm,
              child: Text(!signup ? 'Login' : 'Signup'),
              elevation: 10.0,
              textTheme: ButtonTextTheme.primary,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  signup = !signup;
                });
              },
              child: Text(
                signup ? 'Login' : 'Signup',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
