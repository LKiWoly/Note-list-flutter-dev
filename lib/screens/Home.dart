import 'package:flutter/material.dart';
import 'package:noteslist/components/NotesList.dart';
import 'package:noteslist/screens/NoteAdd.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    var bottomBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.list), title: Text('Your note')),
        BottomNavigationBarItem(
            icon: Icon(Icons.add), title: Text('Create note')),
      ],
      currentIndex: sectionIndex,
      onTap: (int index) {
        setState(() {
          sectionIndex = index;
        });
      },
    );

    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title:
                Text(sectionIndex == 0 ? 'Your notes list' : 'Enter your note'),
            leading: Icon(Icons.list),
          ),
          body: sectionIndex == 0 ? NotesList() : AddNotePage(),
          bottomNavigationBar: bottomBar),
    );
  }
}
