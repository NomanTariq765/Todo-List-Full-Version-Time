import 'package:flutter/material.dart';

import '../dbHelper.dart';
import '../modelClass.dart';
import 'AddNote.dart';
import 'EditeNotes.dart';
// import 'ReadNotes.dart';

class HomeScreen extends StatefulWidget {  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  @override
  void initState() {
    super.initState();
    _refreshNoteList();
  }

  _refreshNoteList() {
    setState(() {
      _noteList = DatabaseHelper.instance.queryAllRows().then(
            (value) => value.map((item) => Note.fromJson(item)).toList(),
      );
    });
  }

  _deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);

    _refreshNoteList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Center(
            child: Text(
              'Todo App',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot<List<Note>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Note> notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.deepPurple,
                        child: Text(
                          notes[index].date,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                notes[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.deepPurple),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                notes[index].Description,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditNoteScreen(note: notes[index]),
                                      ),
                                    ).then((_) => _refreshNoteList());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    _deleteNote(notes[index].id);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ReadNoteScreen(note: notes[index]),
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          ).then((_) => _refreshNoteList());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
