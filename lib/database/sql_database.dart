import 'dart:async';

import 'package:notes_app/database/sql_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future initialDb() async {
    String databasePath = await getDatabasesPath(); //detect a default path
    //to rename database =>
    String path = join(databasePath, 'notes.db'); //databsePath/notes.db
    Database database = await openDatabase(path,
        onCreate: onCreate, version: 1, onUpgrade: onUpgrade);
    return database;
  }

  onUpgrade(Database db, int version, int newversion) {}

  onCreate(Database db, int version) {
    Batch batch = db.batch();
    batch.execute(
      '''CREATE TABLE notes(
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL ,
        content TEXT NOT NULL
        )
        ''',
    );
    batch.execute(
      '''CREATE TABLE todo(
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL ,
        selected INTEGER NOT NULL
        )
        ''',
    );
    batch.commit(); //to work
  }

///////////////////readData/////////////////////////
  Future<List<Map>> readDataNote() async {
    Database? dataDb = await db;
    List<Map> response = await dataDb!.query('notes');
    List<Map> generatedList = [];

    for (int i = 0; i < response.length; i++) {
      Map<String, dynamic> generatedMap = {
        'id': response[i]['id'],
        'title': response[i]['title'],
        'content': response[i]['content'],
      };
      generatedList.add(generatedMap);
    }
    return generatedList;
  }

  Future<List<Map>> readDataToDo() async {
    Database? dataDb = await db;
    List<Map> response = await dataDb!.query('todo');
    return List.generate(response.length, (index) {
      return ToDO(
        id: response[index]['id'],
        title: response[index]['title'],
        selected: response[index]['selected'],
      ).toMap();
    });
  }

//////////////////////insert Data///////////////////////////
  Future insertNote(Note note) async {
    Database? dataDb = await db;
    Batch batch = dataDb!.batch();
    batch.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, //if there is any problem in raws or id
    );
    batch.commit();
  }

  Future insertToDo(ToDO todo) async {
    Database? dataDb = await db;
    Batch batch = dataDb!.batch();
    batch.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, //if there is any problem in raws or id
    );
    batch.commit();
  }

///////////////////updateData/////////////////////
  Future updateNote(Note newNote) async {
    Database? dataDb = await db;
    await dataDb!.update(
      'notes',
      newNote.toMap(),
      where: 'id= ?',
      whereArgs: [newNote.id],
    );
  }

  Future updateToDo(int id, int selected) async {
    Database? dataDb = await db;
    Map<String, dynamic> values = {
      'selected': selected == 0 ? 1 : 0,
    };
    await dataDb!.update(
      'todo',
      values,
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  /////////////deleteData/////////////////////
  Future deleteNote(int id) async {
    Database? dataDb = await db;
    await dataDb!.delete(
      'notes',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  Future deleteToDo(int id) async {
    Database? dataDb = await db;
    await dataDb!.delete(
      'todo',
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  // deleteDb() async {
  //   String databasePath = await getDatabasesPath(); //detect a default path
  //   //to rename database =>
  //   String path = join(databasePath, 'notes.db');
  //   deleteDatabase(path);
  // }
}
