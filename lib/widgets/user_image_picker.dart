import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File _image) imagePicFn;

  UserImagePicker(this.imagePicFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _storedImage;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 50,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    widget.imagePicFn(File(imageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              height: 60.0,
              width: 60.0,
              child: _storedImage == null
                  ? Container(
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                    )
                  : Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          FlatButton.icon(
            onPressed: _getImage,
            icon: Icon(Icons.image),
            label: Text('Add Picture'),
          ),
        ],
      ),
    );
  }
}
