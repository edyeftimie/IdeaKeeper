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
    debugPrint( 'get database called' );
    if (_database != null) {
      debugPrint( 'database already exists' );
      return _database!;
    }
    debugPrint( 'database does not exist' );
    _database = await initDatabase();
    debugPrint( 'database initialized' );
    return _database!;
  }

  Future<Database> initDatabase() async {
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
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    return db.query(entityName);
  }

  Future<void> insert(Map<String, dynamic> entityMap) async {
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    await db.insert(entityName, entityMap);
  }

  Future<void> update(Map<String, dynamic> entityMap) async {
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
    final db = await database;
    String entityName = _entity.runtimeType.toString().toLowerCase();
    await db.delete(
      entityName, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}