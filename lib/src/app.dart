import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/view/list_view.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ro', 'RO'),
      ],
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (routeSettings.name) {
              case '/':
                return ListItemView(repo: repo);
              default:
                return const Scaffold(
                  body: Center(
                    child: Text('404 - Page not found'),
                  ),
                );
            }
          }
        );
      },
    );
  }
} 