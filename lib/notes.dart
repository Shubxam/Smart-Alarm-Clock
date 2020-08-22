import 'package:flutter/material.dart';

class NotesWidget extends StatefulWidget {
  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  List<String> notesList = ["Hello World"];

  void addNoteToList(String noteText) {
    setState(() {
      notesList.add(noteText);
    });
    Navigator.pop(context);
  }

  void deleteNote(index) {
    setState(() {
      notesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: NotesListWidget(notesList, deleteNote),
            height: MediaQuery.of(context).size.height * .7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return AddNewNote(notesList, addNoteToList);
                        });
                  },
                  child: Text("Create New Note"),
                  elevation: 12,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class AddNewNote extends StatefulWidget {
  List<String> notesList;
  Function addNoteToList;

  AddNewNote(this.notesList, this.addNoteToList);
  @override
  _AddNewNoteState createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                      controller: textController,
                      style: TextStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          if ((textController.text).isNotEmpty) {
                            widget.addNoteToList(textController.text);
                          }
                        },
                        child: Text(
                          "Add Note",
                          style: TextStyle(color: Colors.black),
                        ),
                        color: Colors.white,
                      )
                    ],
                  )
                ])));
  }
}

class NotesListWidget extends StatefulWidget {
  List<String> notesList;
  Function deleteNote;
  NotesListWidget(this.notesList, this.deleteNote);
  @override
  _NotesListWidgetState createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (widget.notesList).length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text("${widget.notesList[index]}"),
            trailing: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  widget.deleteNote(index);
                }),
          ),
        );
      },
    );
  }
}
