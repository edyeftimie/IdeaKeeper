import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/web_socket_controller.dart';
import 'package:exam_project/src/mvrc/model/budgetTransaction.dart';
import 'package:exam_project/src/mvrc/settings/settings_controller.dart';
import 'package:exam_project/src/mvrc/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:exam_project/src/app.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/controller/server_controller.dart';


void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || !Platform.isAndroid) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  final SettingsController settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  final AbstractRepo<BudgetTransaction> repo = AbstractRepo(tableName: 'budgetTransactions', fromJson: BudgetTransaction.fromJson);
  await repo.database;

  final ServerController<BudgetTransaction> serverController = ServerController(
    // baseUrl: 'http://192.168.1.128:2419',
    baseUrl: 'http://192.168.154.189:2528',
    onReconnect: () async {
      debugPrint('Reconnected');
    },
    fromJson: BudgetTransaction.fromJson,
  );

  final WebSocketController webSocketController = WebSocketController(
    url: 'ws://192.168.154.189:2528',
    // url: 'ws://192.168.1.128:2419', 
    onReconnect: () async { 
      debugPrint('Reconnected');
      // await serverController.fetchItems();
    },
  );
  webSocketController.connect();

  final Controller<BudgetTransaction> controller = Controller<BudgetTransaction>(
    serverController: serverController,
    repo: repo,
  );
  await controller.initDatabase();
  
  runApp(MyApp<BudgetTransaction>(settingsController: settingsController,controller: controller, fromJson: BudgetTransaction.fromJson));
}
