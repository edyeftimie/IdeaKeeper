import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/view/list_view.dart';
import 'package:exam_project/src/mvrc/view/add_or_edit_item_view.dart ';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class MyApp<T extends Entity> extends StatelessWidget {
  // final AbstractRepo<T> repo;
  final Controller<T> controller;
  final T Function(Map<String, dynamic> json) fromJson;

  const MyApp({
    Key? key,
    // required this.repo,
    required this.controller,
    required this.fromJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXAM Eftimie Eduard-Costin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ro', 'RO'),
      ],
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            final Uri uri = Uri.parse(routeSettings.name!);
            debugPrint (uri.path);
            switch (uri.path) {
              case '/':
                return ListItemView(controller: controller);
              case '/add_edit_item':
                int? idAux;
                if (uri.queryParameters['id'] != null) {
                  idAux = int.parse(uri.queryParameters['id']!);
                }
                return AddEditItem<T>(
                  // repo: repo,
                  controller: controller,
                  id: idAux,
                  fromJson: fromJson,
                );
              default:
                return ListItemView(controller: controller);
            }
          }
        );
      },
    );
  }
} 