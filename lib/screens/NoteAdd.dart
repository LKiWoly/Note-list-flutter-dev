import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNotePage> {
  TextEditingController _inputTitleTextController = TextEditingController();
  TextEditingController _inputDescriptionController = TextEditingController();

  File userImage;
  var userImageUrl;

  @override
  Widget build(BuildContext context) {
    Widget _userInput(String hint, TextEditingController controller) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black38),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54, width: 1)),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: IconThemeData(color: Colors.white),
                  child: Icon(Icons.message),
                ),
              )),
        ),
      );
    }

    _chooseImageFunction() async {
      var picture = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        userImage = picture;
      });
    }

    Widget _createNoteButton(String text, void func()) {
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 20)),
        onPressed: () {
          func();
        },
      );
    }

    Widget _userInputDescription(
        String createButtonLabel, String uploadImageButtonLabel, void func()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: _userInput(
                  'Enter note title here!', _inputTitleTextController),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: _userInput(
                  'Enter note description here!', _inputDescriptionController),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _createNoteButton(createButtonLabel, func),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _createNoteButton(
                    uploadImageButtonLabel, _chooseImageFunction),
              ),
            )
          ],
        ),
      );
    }

    _uploadImage() async {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(userImage.path);
      StorageUploadTask uploadTask = storageReference.putFile(userImage);
      await uploadTask.onComplete;
      var downloadImageUrl = await storageReference.getDownloadURL();

      setState(() {
        userImageUrl = downloadImageUrl;
      });
    }

    void _createNote() async {
      if (userImage != null) await _uploadImage();

      Map<String, dynamic> data = {
        'title': _inputTitleTextController.text,
        'description': _inputDescriptionController.text,
        'image': userImageUrl
      };
      CollectionReference collectionReference =
          Firestore.instance.collection('data');
      collectionReference.add(data);

      _inputTitleTextController.clear();
      _inputDescriptionController.clear();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          child: _userInputDescription('CREATE', 'UPLOAD IMAGE', _createNote)),
    );
  }
}
