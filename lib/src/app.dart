import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/view/list_view.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/view/add_or_edit_item_view.dart ';
import 'package:exam_project/src/mvrc/model/test_entity.dart';

class MyApp extends StatelessWidget {
  final AbstractRepo<TestEntity> repo;

  const MyApp({
    Key? key,
    required this.repo,
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
                return ListItemView(repo: repo);
              case '/add_edit_item':
                int? idAux;
                if (uri.queryParameters['id'] != null) {
                  idAux = int.parse(uri.queryParameters['id']!);
                }
                return AddEditItem<TestEntity>(
                  repo: repo,
                  id: idAux,
                  fromJson: TestEntity.fromJson,
                );
              default:
                return ListItemView(repo: repo);
            }
          }
        );
      },
    );
  }
} 