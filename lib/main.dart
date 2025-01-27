import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:exam_project/src/app.dart';
import 'package:exam_project/src/mvrc/model/test_entity.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || !Platform.isAndroid) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final AbstractRepo<TestEntity> repo = AbstractRepo(tableName: 'testing', fromJson: TestEntity.fromJson);
  await repo.database;
  
  runApp(MyApp<TestEntity>(repo: repo, fromJson: TestEntity.fromJson));
}
