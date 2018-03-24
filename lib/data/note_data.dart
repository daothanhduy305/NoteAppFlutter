import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Some constants used by database
const String dbName = "note_app.db";
const String tableName = "notes";
// Columns' name
const String columnId = "_id";
const String columnTitle = "title";
const String columnContent = "content";
const String columnDate = "createdTime";

class NoteData {
	int id; // For sql primary key
	String title, content;
	DateTime createdDate;

	NoteData([this.title, this.content, this.createdDate]);

	// To transform NoteData to a map
	Map toMap() {
		Map returningMap = {
			columnTitle: title,
			columnContent: content,
			columnDate: createdDate.toIso8601String(),
		};
		if (id != null) returningMap[columnId] = id;
		return returningMap;
	}

	// To construct NoteData from map
	NoteData.fromMap(Map map) {
		id = map[columnId];
		title = map[columnTitle];
		content = map[columnContent];
		createdDate = DateTime.parse(map[columnDate]);
	}

}

class NoteDataProvider {
	// Singleton Pattern
	static final NoteDataProvider _noteDataProvider = new NoteDataProvider
		._internal();

	NoteDataProvider._internal();

	static NoteDataProvider getInstance() => _noteDataProvider;

	Database database;

	Future open() async {
		Directory documentsDirectory = await getApplicationDocumentsDirectory();
		String path = join(documentsDirectory.path, dbName);

		database = await openDatabase(
			path,
			version: 1,
			onCreate: (db, ver) async {
				await db.execute(
					'''
						create table $tableName(
							$columnId integer primary key autoincrement,
							$columnTitle text not null,
							$columnContent text not null,
							$columnDate string not null
						);
						'''
					);
			}
			);
	}

	Future<NoteData> insert(NoteData noteData) async {
		await open();
		noteData.id = await database.insert(tableName, noteData.toMap());
		await close();
		return noteData;
	}

	Future<NoteData> getNoteData(int id) async {
		await open();
		List<Map> maps = await database.query(
			tableName,
			columns: [columnId, columnTitle, columnContent, columnDate],
			where: "$columnId = ?",
			whereArgs: [id]);
		await close();

		return maps.length > 0 ? new NoteData.fromMap(maps.first) : null;
	}

	Future<List<NoteData>> getAllNoteData() async {
		await open();
		List<Map> maps = await database.query(
			tableName,
			columns: [columnId, columnTitle, columnContent, columnDate],
			);
		await close();

		return maps.map((map) => new NoteData.fromMap(map)).toList();
	}

	Future<int> delete(int id) async {
		await open();
		var result = await database.delete(
			tableName,
			where: "$columnId = ?",
			whereArgs: [id]
			);
		await close();

		return result;
	}

	Future<int> update(NoteData noteData) async {
		await open();
		var result = await database.update(
			tableName,
			noteData.toMap(),
			where: "$columnId = ?",
			whereArgs: [noteData.id]
			);
		await close();

		return result;
	}

	Future close() async => database.close();

}