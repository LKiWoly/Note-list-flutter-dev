import 'package:flutter/material.dart';
import 'package:noteslist/screens/Home.dart';
import 'package:noteslist/screens/NoteAdd.dart';

void main() => runApp(NotesTracker());

class NotesTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Your notes', home: HomePage());
  }
}
