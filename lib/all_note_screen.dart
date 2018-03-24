import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/data/note_data.dart';
import 'package:note_app/new_note_screen.dart';

class AllNoteScreen extends StatefulWidget {
	final List<NoteData> data;

	AllNoteScreen(this.data);

	@override
	State<StatefulWidget> createState() => new AllNoteScreenState(data);

}

class AllNoteScreenState extends State<AllNoteScreen> {
	final List<NoteData> data;

	AllNoteScreenState(this.data);

	final DateFormat dateFormat = new DateFormat("H:m, dd/MM/yyyy");

	@override
	Widget build(BuildContext context) =>
		new ListView.builder(
			padding: new EdgeInsets.only(top: 10.0),
			itemBuilder: (context, index) {
				if (index < data.length)
					return buildNoteTile(data[index], index == data.length - 1);
			},
		);

	Widget buildNoteTile(NoteData noteData, [bool isLast = false]) {
		var noteTile = new ListTile(
			title: new Padding(
				padding: new EdgeInsets.only(top: 10.0),
				child: new Text(noteData.title),
			),
			subtitle: new Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: <Widget>[
					new Text(noteData.content),
					new Container(
						padding: new EdgeInsets.only(top: 20.0, bottom: 10.0),
						child: new Text(
							dateFormat.format(noteData.createdDate)),
					)
				],
			),
			onLongPress: () =>
				showDialog(
					context: context,
					child: new SimpleDialog(
						title: new Text(noteData.title,),
						children: <Widget>[
							new SimpleDialogOption(
								child: new Text('Edit', style: new TextStyle(
									fontSize: 18.0),),
								onPressed: () async {
									Navigator.pop(context);
									NoteData newNoteData = await Navigator.of(
										context).push(
										new MaterialPageRoute<NoteData>(
											builder: (context) =>
											new NewNoteScreen(noteData.title,
												noteData
													.content,
												"Edit Note")
										));
									if (newNoteData != null) {
										newNoteData.id = noteData.id;
										newNoteData.createdDate =
											noteData.createdDate;
										await NoteDataProvider.getInstance()
											.update(newNoteData);
										setState(() {
											noteData.title = newNoteData.title;
											noteData.content =
												newNoteData.content;
										});
									}
								},
							),
							new Divider(),
							new SimpleDialogOption(
								child: new Text('Delete', style: new TextStyle(
									fontSize: 18.0),),
								onPressed: () async {
									// We wait for db changes to ensure
									await NoteDataProvider.getInstance().delete(
										noteData.id);
									// Use primary key to indicate data in list
									setState(() =>
										data.removeWhere((note) =>
										note.id ==
											noteData.id));
									// Then dismiss the dialog
									Navigator.pop(context);
								}
							),
						],
					)
				),
		);

		if (isLast)
			return noteTile;
		else
			return new Column(
				children: <Widget>[
					noteTile,
					new Divider()
				],
			);
	}

}