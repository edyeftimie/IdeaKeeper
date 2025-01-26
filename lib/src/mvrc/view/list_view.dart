import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'dart:math';

class ListItemView extends StatefulWidget {
  const ListItemView({Key? key, required this.repo}) : super(key: key);

  final AbstractRepo repo;

  @override
  _ListItemViewState createState() => _ListItemViewState();
}

class _ListItemViewState extends State<ListItemView> {
  @override
  void initState() {
    super.initState();
    widget.repo.database;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> TODO() {
    // TODO
    debugPrint("TODO");
    return Future.value(); // returns a future with no result
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
    debugPrint (luminance.toString());
    /* 
    BRIGHT:
      .00008
      .00004
      .00005
      .00013
      .00024
    DARK:
      .00017
      .00010
      .00014
      .00027
      .00011
    */
    return luminance < 0.00017 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View'),
      ),
      body: FutureBuilder(
        future: widget.repo.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            final items = snapshot.data as List<dynamic>;
            return RefreshIndicator(
              onRefresh: TODO,
              child: ListView.builder(
                restorationId: 'listItems',
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final dynamic item = items[index];
                  // Color colourBackground = randomColour();
                  // Color colourText = chooseColorContrast(colourBackground);
                  Color colourBackground = Colors.red;
                  Color colourText = Colors.white;
                  return GestureDetector(
                    onTap: () {
                      TODO;
                    },
                    onLongPress: () {
                      TODO;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colourBackground,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var key in item.keys)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text (
                                  key.toString().toUpperCase(),
                                  style: TextStyle(fontSize: 20, color: colourText, fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    ': ${item[key]}',
                                    style: TextStyle(fontSize: 20, color: colourText),
                                  ),
                                )
                              ],

                            )
                            // Text(
                            //   '${item[key]}',
                            //   style: TextStyle(fontSize: 20, color: colourText, fontWeight: FontWeight.bold),
                            // ),
                        ],
                      ),
                    ),
                  );
                },
              )
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}