import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AbstractRepo {
  AbstractRepo._();
  static final AbstractRepo _instance = AbstractRepo._();
  static Database? _database;
  static dynamic _entity;

  factory AbstractRepo(entity) {
    _entity = entity;
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    debugPrint( 'database does not exist' );
    _database = await initDatabase();
    debugPrint( 'database initialized' );
    return _database!;
  }

  Future<Database> initDatabase() async {
    debugPrint( 'initDatabase called' );
    String entityName = _entity.runtimeType.toString().toLowerCase();
    debugPrint (entityName);
    final databasePath = await getDatabasesPath();
    final path = '$databasePath$entityName.db';
    debugPrint (path);
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint( 'onCreate called' );
    String entityName = _entity.runtimeType.toString().toLowerCase();
    String sqlQuery = ''' 
      CREATE TABLE $entityName(
        id INTEGER PRIMARY KEY
    ''';
    Map<String, dynamic> entityMap = _entity.toJson();
    for (var key in entityMap.keys) {
      if (key == 'id') {
        continue;
      }
      sqlQuery += ', $key TEXT';
    }
    sqlQuery += ')';
    // print(sqlQuery);
    debugPrint(sqlQuery);

    await db.execute(sqlQuery);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    debugPrint ('getAll called');
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    dynamic answer = await db.query(entityName);
    print (answer);
    return answer;
  }

  Future<void> insert(Map<String, dynamic> entityMap) async {
    debugPrint ('insert called');
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    entityMap['id'] = await getAvailableId();
    await db.insert(entityName, entityMap);
  }

  Future<int> getAvailableId() async {
    debugPrint ('getAvailableId called');
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery('SELECT MAX(id)+1 as id FROM ${_entity.runtimeType.toString().toLowerCase()}');
    if (maps[0]['id'] == null) {
      return 1;
    } else {
      return maps[0]['id'];
    }
  }

  Future<void> update(Map<String, dynamic> entityMap) async {
    debugPrint ('update called');
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    await db.update(
      entityName, 
      entityMap, 
      where: 'id = ?', 
      whereArgs: [entityMap['id']]
    );
  }

  Future<void> delete(int id) async {
    debugPrint ('delete called');
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    await db.delete(
      entityName, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<Map<String, dynamic>> getById(int id) async {
    debugPrint ('getById called');
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    List<Map<String, dynamic>> maps = await db.query(
      entityName, 
      where: 'id = ?', 
      whereArgs: [id]
    );
    return maps[0];
  }

  Future<void> close() async {
    debugPrint ('close called');
    final db = await database;
    db.close();
  }
}