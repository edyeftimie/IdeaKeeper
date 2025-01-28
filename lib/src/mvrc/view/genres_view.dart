import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/globals.dart';

class ListGenresView extends StatefulWidget {
  // final AbstractRepo repo;
  final Controller controller;

  // const ListItemView({Key? key, required this.repo}) : super(key: key);
  const ListGenresView({Key? key, required this.controller}) : super(key: key);

  @override
  _ListGenresViewState createState() => _ListGenresViewState();
}

class _ListGenresViewState extends State<ListGenresView> {
  late ValueNotifier<List<String>> _itemsNotifier;

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
    //if network is available
    if (isOnline.value == true) {
      final items = await widget.controller.serverController.getGenres();
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
      body: ValueListenableBuilder<List<String>>(
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: colourText,
                                      fontWeight: FontWeight.bold),
                                ),
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
