import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:exam_project/src/mvrc/model/offline_action.dart';

class OfflineRepository {
  final String tableName = 'offline_actions';
  final Function(Map<String, dynamic> json) fromJson;
  Database? _database;

  OfflineRepository({required this.fromJson});

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath$tableName.db';
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    String sqlQuery = ''' 
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        action TEXT,
        entityId INTEGER
      )
    ''';
    await db.execute(sqlQuery);
  }

  Future<List<OfflineAction>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return OfflineAction(
        id: maps[i]['id'],
        action: maps[i]['action'],
        entityId: maps[i]['entityId'],
      );
    });
  }

  Future<void> insert(OfflineAction action) async {
    final db = await database;
    await db.insert(
      tableName,
      action.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}