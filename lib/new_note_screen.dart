import 'package:flutter/material.dart';
import 'package:note_app/data/note_data.dart';

class NewNoteScreen extends StatefulWidget {
	final String title;
	final String content;
	final String appBarTitle;

	NewNoteScreen([this.title = '', this.content = '', this.appBarTitle = 'New Note']);

	@override
	State<StatefulWidget> createState() => new NewNoteScreenState(title, content, appBarTitle);

}

class NewNoteScreenState extends State<NewNoteScreen> {
	final String appBarTitle;
	final GlobalKey<FormState> formKey = new GlobalKey();

	String title;
	String content;

	NewNoteScreenState(this.title, this.content, this.appBarTitle);

	@override
	Widget build(BuildContext context) {

		return new Scaffold(
			appBar: new AppBar(
				title: new Text(appBarTitle),
				actions: <Widget>[
					new IconButton(
							icon: new Icon(Icons.check),
							onPressed: () {
								final form = formKey.currentState;
								// Validate successful and call onSave
								if (form.validate()) {
									form.save();
									Navigator.of(context).pop(new NoteData(
											title, content, new DateTime.now()
											));
								}
							})
				],
				),
			body: new Form(
				key: formKey,
				autovalidate: true,
				child: new Column(
					mainAxisSize: MainAxisSize.max,
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						new Padding(
							padding: new EdgeInsets.all(10.0),
							child: new TextFormField(
								decoration: new InputDecoration(
									hintText: 'Note title',
									),
								style: new TextStyle(
										fontSize: 22.0,
										color: Colors.black87
										),
								maxLines: 1,
								autofocus: true,
								initialValue: title,
								validator: (text) => text.isEmpty? 'Empty title': null,
								onSaved: (val) => title = val,
								),
							),
						new Padding(
							padding: new EdgeInsets.all(10.0),
							child: new TextFormField(
								decoration: new InputDecoration.collapsed(
										hintText: 'Note content'
										),
								style: new TextStyle(
										fontSize: 18.0,
										color: Colors.black87
										),
								maxLines: null,
								keyboardType: TextInputType.multiline,
								initialValue: content,
								validator: (text) => text.isEmpty? 'Empty content': null,
								onSaved: (val) => content = val,
								),
							),
					],
					),
			),
			);
	}

}