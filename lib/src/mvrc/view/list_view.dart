import 'package:flutter/material.dart';
// import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/controller/controller.dart';
// import 'package:flutter/src/foundation/change_notifier.dart';
import 'dart:math';

class ListItemView extends StatefulWidget {
  // final AbstractRepo repo;
  final Controller controller;

  // const ListItemView({Key? key, required this.repo}) : super(key: key);
  const ListItemView({Key? key, required this.controller}) : super(key: key);

  @override
  _ListItemViewState createState() => _ListItemViewState();
}

class _ListItemViewState extends State<ListItemView> {
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
    // final items = await widget.repo.getAll();
    final items = await widget.controller.repo.getAll();
    if (items.isEmpty) {
      debugPrint('No items found');
      return;
    }
    _itemsNotifier.value = items.map((e) => e.toJson()).toList();
  }

  Future<void> _navigateToEdit(BuildContext context, dynamic item) async {
    int idAux = int.parse(item['id'].toString());
    final result = await Navigator.of(context).pushNamed('/add_edit_item?id=$idAux');
    if (result != null && result is Map<String, dynamic>) {
      final index = _itemsNotifier.value.indexWhere((e) => e['id'] == result['id']);
      if (index != -1) {
        _itemsNotifier.value[index] = result;
        _itemsNotifier.value = List<Map<String, dynamic>>.from(_itemsNotifier.value);
      }
      debugPrint('Item updated');
    }
  }

  Future<void> _navigateToAdd(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/add_edit_item');
    if (result != null && result is Map<String, dynamic>) {
      _itemsNotifier.value.add(result);
      _itemsNotifier.value = List<Map<String, dynamic>>.from(_itemsNotifier.value);
      debugPrint('Item added');
    }
  }

  Future<void> _navigateToDelete(BuildContext context, dynamic item) async {
    int idAux = int.parse(item['id'].toString());
    // await widget.repo.delete(idAux); // Assuming delete operation handled by repo.
    await widget.controller.repo.delete(idAux);
    _itemsNotifier.value.removeWhere((e) => e['id'] == idAux);
    _itemsNotifier.value = List<Map<String, dynamic>>.from(_itemsNotifier.value);
    debugPrint('Item deleted');
  }

  Color randomColour() {
    return Color((int.parse('0xFF${(1 + Random().nextInt(0xFFFFFF)).toRadixString(16).padLeft(6, '0')}')));
  }

  double computeLuminance(Color color) {
    double r = color.r / 255;
    double g = color.g / 255;
    double b = color.b / 255;

    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  Color chooseColorContrast(Color color) {
    double luminance = computeLuminance(color);
    debugPrint(luminance.toString());
    return luminance < 0.00017 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building list view');
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View'),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _itemsNotifier,
        builder: (context, items, child) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _loadItems,
                child: ListView.builder(
                  restorationId: 'listItems',
                  itemCount: items.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final dynamic item = items[index];
                    Color colourBackground = Colors.red;
                    Color colourText = Colors.white;
                    return GestureDetector(
                      onTap: () {
                        _navigateToEdit(context, item);
                      },
                      onLongPress: () {
                        _navigateToDelete(context, item);
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
                                )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    _navigateToAdd(context);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
