import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/web_socket_controller.dart';
import 'package:exam_project/src/mvrc/model/budgetTransaction.dart';
import 'package:exam_project/src/mvrc/settings/settings_controller.dart';
import 'package:exam_project/src/mvrc/settings/settings_service.dart';
// import 'package:exam_project/src/mvrc/view/widgets/progress_indicator.dart';
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

  runApp(MyAppInitializer(settingsController: settingsController));
}

class MyAppInitializer extends StatelessWidget {
  final SettingsController settingsController;

  MyAppInitializer({required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing app'),
              ),
            ),
          );
        } else {
          final controller = snapshot.data as Controller<BudgetTransaction>;
          return MyApp<BudgetTransaction>(
            settingsController: settingsController,
            controller: controller,
            fromJson: BudgetTransaction.fromJson,
          );
        }
      },
    );
  }

  Future<Controller<BudgetTransaction>> _initializeApp(BuildContext context) async {
    final AbstractRepo<BudgetTransaction> repo = AbstractRepo(tableName: 'budgetTransactions', fromJson: BudgetTransaction.fromJson);
    await repo.database;

    final ServerController<BudgetTransaction> serverController = ServerController(
      baseUrl: 'http://192.168.1.128:2528',
      onReconnect: () async {
        debugPrint('Reconnected');
      },
      fromJson: BudgetTransaction.fromJson,
    );

    final WebSocketController webSocketController = WebSocketController(
      url: 'ws://192.168.1.128:2528',
      onReconnect: () async {
        debugPrint('Reconnected');
      },
    );

    // showLoading(context);

    webSocketController.connect();

    final Controller<BudgetTransaction> controller = Controller<BudgetTransaction>(
      serverController: serverController,
      repo: repo,
    );

    await controller.initDatabase(context);

    // hideLoading(context);

    return controller;
  }
}

// void main() async {
//   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || !Platform.isAndroid) {
//       sqfliteFfiInit();
//       databaseFactory = databaseFactoryFfi;
//   }

//   WidgetsFlutterBinding.ensureInitialized();

//   final SettingsController settingsController = SettingsController(SettingsService());
//   await settingsController.loadSettings();

//   final AbstractRepo<BudgetTransaction> repo = AbstractRepo(tableName: 'budgetTransactions', fromJson: BudgetTransaction.fromJson);
//   await repo.database;

//   final ServerController<BudgetTransaction> serverController = ServerController(
//     // baseUrl: 'http://192.168.1.128:2419',
//     // baseUrl: 'http://192.168.154.189:2528',
//     baseUrl: 'http://192.168.1.128:2528', 
//     onReconnect: () async {
//       debugPrint('Reconnected');
//     },
//     fromJson: BudgetTransaction.fromJson,
//   );

//   final WebSocketController webSocketController = WebSocketController(
//     // url: 'ws://192.168.154.189:2528',
//     // url: 'ws://192.168.1.128:2419', 
//     url: 'ws://192.168.1.128:2528', 
//     onReconnect: () async { 
//       debugPrint('Reconnected');
//       // await serverController.fetchItems();
//     },
//   );

//   showLoading(context);

//   webSocketController.connect();

//   final Controller<BudgetTransaction> controller = Controller<BudgetTransaction>(
//     serverController: serverController,
//     repo: repo,
//   );
//   await controller.initDatabase(context);
//   hideLoading(context);
  
//   runApp(MyApp<BudgetTransaction>(settingsController: settingsController,controller: controller, fromJson: BudgetTransaction.fromJson));
// }
