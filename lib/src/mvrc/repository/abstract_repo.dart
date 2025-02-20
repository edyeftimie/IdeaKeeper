import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class AbstractRepo <T extends Entity> {
  final String tableName;
  final T Function(Map<String, dynamic> json) fromJson;
  Database? _database;

  AbstractRepo({required this.tableName, required this.fromJson});

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    debugPrint( 'REPO: database does not exist' );
    _database = await initDatabase();
    debugPrint( 'REPO: database initialized' );
    return _database!;
  }

  Future<Database> initDatabase() async {
    debugPrint( 'REPO: initDatabase called' );
    final databasePath = await getDatabasesPath();
    final path = '$databasePath$tableName.db';
    debugPrint (path);
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint( 'REPO: onCreate called' );
    String sqlQuery = ''' 
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY
    ''';
    T tempInstance = fromJson({});
    Map<String, dynamic> entityMap = tempInstance.toJson();
    for (var key in entityMap.keys) {
      if (key == 'id') {
        continue;
      }
      sqlQuery += ', $key TEXT';
    }
    sqlQuery += ')';
    debugPrint(sqlQuery);

    await db.execute(sqlQuery);
  }

  Future<List<T>> getAll() async {
    debugPrint ('REPO: getAll called');
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    debugPrint ('maps: $maps');
    List<T> entities = [];
    for (var map in maps) {
      debugPrint (map.toString());
      entities.add(fromJson(map));
    }
    debugPrint (entities.toString());
    return entities;
  }

  Future<void> insert(T entity, int? id) async {
    debugPrint ('REPO: insert called');
    final db = await database;
    // debugPrint ('entity.id: ${entity.id}');
    id ??= await getAvailableId(); // if id is null, get the next available id 
    entity.id = id;
    // debugPrint ('entity.id: ${entity.id}');
    await db.insert(tableName, entity.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getAvailableId() async {
    debugPrint ('REPO: getAvailableId called');
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery('SELECT MAX(id)+1 as id FROM $tableName');
    if (maps[0]['id'] == null) {
      return 1;
    } else {
      return maps[0]['id'];
    }
  }

  // Future<void> update(T entity) async {
  //   debugPrint ('REPO: update called');
  //   final db = await database;
  //   await db.update(
  //     tableName, 
  //     entity.toJson(),
  //     where: 'id = ?', 
  //     whereArgs: [entity.id]
  //   );
  // }

  Future<void> delete(int id) async {
    debugPrint ('REPO: delete called');
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<T> getById(int id) async {
    debugPrint ('REPO: getById called');
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?', 
      whereArgs: [id]
    );
    return fromJson(maps[0]);
  }

  Future<void> close() async {
    debugPrint ('REPO: close called');
    final db = await database;
    db.close();
  }
}