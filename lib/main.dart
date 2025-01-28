import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/web_socket_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:exam_project/src/app.dart';
// import 'package:exam_project/src/mvrc/model/test_entity.dart';
import 'package:exam_project/src/mvrc/model/book.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/controller/server_controller.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || !Platform.isAndroid) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();
  // create and T that has the TestEnity as the type
  // final AbstractRepo<TestEntity> repo = AbstractRepo(tableName: 'testing', fromJson: TestEntity.fromJson);
  final AbstractRepo<Book> repo = AbstractRepo(tableName: 'books3', fromJson: Book.fromJson);
  await repo.database;
  final ServerController<Book> serverController = ServerController(
    baseUrl: 'http://192.168.1.128:2419',
    onReconnect: () async {
      debugPrint('Reconnected');
    },
    fromJson: Book.fromJson,
  );

  final WebSocketController webSocketController = WebSocketController(
    url: 'ws://192.168.1.128:2419', 
    onReconnect: () async { 
      debugPrint('Reconnected');
      // await serverController.fetchItems();
    },
  );
  webSocketController.connect();

  final Controller<Book> controller = Controller<Book>(
    serverController: serverController,
    repo: repo,
  );
  await controller.initDatabase();
  
  runApp(MyApp<Book>(controller: controller, fromJson: Book.fromJson));
  // runApp(MyApp<TestEntity>(repo: repo, fromJson: TestEntity.fromJson));
}
