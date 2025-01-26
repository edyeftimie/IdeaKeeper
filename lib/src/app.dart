import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/view/list_view.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/view/add_or_edit_item_view.dart ';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.repo,
  });

  final AbstractRepo repo;


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
            print (uri.path);
            switch (uri.path) {
              case '/':
                return ListItemView(repo: repo);
              case '/add_edit_item':
                if (uri.queryParameters['id'] != null) {
                  return AddEditItem(repo: repo, id: int.parse(uri.queryParameters['id']!));
                }
                return AddEditItem(repo: repo, id: null);
              default:
                return ListItemView(repo: repo);
            }
          }
        );
      },
    );
  }
} 