import 'package:exam_project/src/mvrc/settings/settings_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:exam_project/src/mvrc/view/list_view.dart';
// import '../../../old/genres_view.dart';
import 'package:exam_project/src/mvrc/view/menu_view.dart';
import 'package:exam_project/src/mvrc/view/add_or_edit_item_view.dart ';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';
// import 'package:exam_project/src/mvrc/view/books_genre_view.dart';
import 'package:exam_project/src/mvrc/view/monthly_analysis.dart';
import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/settings/settings_controller.dart';

class MyApp<T extends Entity> extends StatelessWidget {
  final SettingsController settingsController;
  final Controller<T> controller;
  final T Function(Map<String, dynamic> json) fromJson;

  const MyApp({
    Key? key,
    required this.settingsController,
    required this.controller,
    required this.fromJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            // AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          title: 'EXAM Eftimie Eduard-Costin',
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          //   useMaterial3: true,
          // ),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ro', 'RO'),
          ],
          // onGenerateTitle: (BuildContext context) =>
          //   AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute(
              settings: routeSettings,
              builder: (context) {
                final Uri uri = Uri.parse(routeSettings.name!);
                debugPrint (uri.path);
                switch (uri.path) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case '/':
                    return MenuView();
                  case '/list_items':
                    return ListItemView(controller: controller);
                  case '/monthly_analysis':
                    return MonthlyAnalysis(controller: controller);
                  // case '/genres_list':
                  //   return ListGenresView(controller: controller);
                  // case '/books_by_genre':
                  //   return ListBooksGenreView(controller: controller, genre: uri.queryParameters['genre'] ?? 'default_genre');
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
                    return MenuView();
                    // return ListItemView(controller: controller);
                }
              }
            );
          },
        );
      }
    );
  }
} 