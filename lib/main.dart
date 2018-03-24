import 'package:flutter/material.dart';
import 'package:note_app/all_note_screen.dart';
import 'package:note_app/data/note_data.dart';
import 'package:note_app/new_note_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: 'Note',
            theme: new ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: new MyHomePage(title: 'Note'),
            routes: {
                '/new_note': (context) => new NewNoteScreen(),
            },
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final NoteDataProvider noteDataProvider = NoteDataProvider.getInstance();
    final List<NoteData> notes = new List();

    _MyHomePageState() {
        noteDataProvider.getAllNoteData().then((data) =>
            setState(() {
                notes.addAll(data);
            }));
    }

    @override
    Widget build(BuildContext context) =>
        new Scaffold(
            appBar: new AppBar(
                title: new Text(widget.title),
            ),
            body: new Center(
                child: new AllNoteScreen(notes),
            ),
            floatingActionButton: new Builder(
                builder: (context) {
                    return new FloatingActionButton(
                        onPressed: () async {
                            var data = await Navigator.of(context).pushNamed(
                                '/new_note');
                            if (data != null) addNewNote(data);
                        },
                        tooltip: 'Add new note',
                        child: new Icon(Icons.add),
                    );
                },
            ),
        );

    void addNewNote(NoteData newNote) async =>
        noteDataProvider.insert(newNote).then((addedNote) =>
            setState(() {
                notes.add(addedNote);
            }));

}
