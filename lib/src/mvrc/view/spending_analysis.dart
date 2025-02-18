import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:exam_project/src/mvrc/controller/globals.dart';

class SpendingAnalaysis extends StatefulWidget {
  final Controller controller;

  const SpendingAnalaysis({Key? key, required this.controller}) : super(key: key);

  @override
  _MonthlyAnalysisState createState() => _MonthlyAnalysisState();
}

class _MonthlyAnalysisState extends State<SpendingAnalaysis> {
  late ValueNotifier<Map<String, double>> _itemsNotifier;

  @override
  void initState() {
    super.initState();
    _itemsNotifier = ValueNotifier({});
    _loadItems();
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    if (isOnline.value == true) {
      final items = await widget.controller.serverController.getAll();
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

    @override
  Widget build(BuildContext context) {
    debugPrint('Building genres view');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres View'),
      ),
      body: ValueListenableBuilder<Map<String, double>>(
        valueListenable: _itemsNotifier,
        builder: (context, items, child) {
          var sortedItems = items.entries.toList()..sort((e2, e1) => e2.value.compareTo(e1.value));
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _loadItems,
                child: ListView.builder(
                  restorationId: 'analysis',
                  itemCount: items.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    // final dynamic item = items[index];
                    final item = sortedItems[index].key;
                    Color colourBackground = Colors.red;
                    Color colourText = Colors.white;
                    return GestureDetector(
                      onTap: () {
                        // _navigateToBooksByGenre(context, item);
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
                                Text (
                                  ' - ${items[item]}',
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