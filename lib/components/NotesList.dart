import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteslist/domain/Note.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> data = [];
  bool updateListNotes = true;
  var noteBoxHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    if (updateListNotes) {
      _updateData();
    }
    var notesList = Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                  height: 40,
                  child: RaisedButton(
                    child: Center(
                        child: Text(
                      data[i].noteTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )),
                    onPressed: () {
                      setState(() {
                        noteBoxHeight = (noteBoxHeight == 0.0 ? 280.0 : 0.0);
                      });
                    },
                  ),
                ),
                AnimatedContainer(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
                  child: Container(
                      margin:
                          EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.5)),
                      child: Column(
                        children: [
                          Container(
                            height: 10,
                          ),
                          data[i].imageUrl != 'null'
                              ? InkResponse(
                                  child: Image.network(data[i].imageUrl,
                                      height: 200),
                                )
                              : Container(
                                  height: 10,
                                ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            data[i].noteDescription,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  height: noteBoxHeight,
                )
              ],
            );
          }),
    );

    return Container(child: notesList);
  }

  _updateData() {
    updateListNotes = false;
    CollectionReference collectionReference =
        Firestore.instance.collection('data');
    collectionReference.snapshots().listen((snapshot) {
      List documents;

      setState(() {
        documents = snapshot.documents;
        for (var curNote in documents) {
          data.add(Note(
              noteTitle: curNote.data['title'].toString(),
              noteDescription: curNote.data['description'].toString(),
              imageUrl: curNote.data['image'].toString()));
        }
      });
    });
  }
}
