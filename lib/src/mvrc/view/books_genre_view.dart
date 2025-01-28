import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/globals.dart';

class ListBooksGenreView extends StatefulWidget {
  // final AbstractRepo repo;
  final Controller controller;
  final String genre;

  // const ListItemView({Key? key, required this.repo}) : super(key: key);
  const ListBooksGenreView({Key? key, required this.controller, required this.genre}) : super(key: key);

  @override
  _ListBooksGenreViewState createState() => _ListBooksGenreViewState();
}

class _ListBooksGenreViewState extends State<ListBooksGenreView> {
  late ValueNotifier<List<Map<String, dynamic>>> _itemsNotifier;

  @override
  void initState() {
    super.initState();
    _itemsNotifier = ValueNotifier([]);
    _loadItems();
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    if (isOnline.value == true) {
      final items = await widget.controller.serverController.getBooksByGenre(widget.genre);
      if (items.isEmpty) {
        debugPrint('No items found');
        return;
      }
      _itemsNotifier.value = items;
    } else {
      debugPrint('No internet connection');
      Navigator.of(context).pop();
    }
  }

  Future<void> _navigateToBooksByGenre(BuildContext context, String genre) async {
    if (isOnline.value == false) {
      debugPrint('No internet connection');
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushNamed('/books_by_genre?genre=$genre');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building genres view');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres View'),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _itemsNotifier,
        builder: (context, items, child) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _loadItems,
                child: ListView.builder(
                  restorationId: 'listGenres',
                  itemCount: items.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final dynamic item = items[index];
                    Color colourBackground = Colors.red;
                    Color colourText = Colors.white;
                    return GestureDetector(
                      onTap: () {
                        _navigateToBooksByGenre(context, item);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colourBackground,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var key in item.keys)
                              if (key != 'id') 
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      key.toString().toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: colourText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        ': ${item[key]}',
                                        style: TextStyle(fontSize: 20, color: colourText),
                                      ),
                                    )
                                  ],
                                ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
