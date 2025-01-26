import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';

class ListItemView extends StatefulWidget {
  const ListItemView({Key? key, required this.repo}) : super(key: key);

  final AbstractRepo repo;

  @override
  _ListItemViewState createState() => _ListItemViewState();
}

class _ListItemViewState extends State<ListItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View'),
      ),
      body: FutureBuilder(
        future: widget.repo.database,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Text('Database initialized'),
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