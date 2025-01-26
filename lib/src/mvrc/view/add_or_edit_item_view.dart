import 'package:exam_project/src/mvrc/model/test_entity.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/view/widgets/item_form.dart';


class AddEditItem extends StatefulWidget {
  const AddEditItem({Key? key, required this.repo, required this.id}) : super(key: key);

  static const routeName = '/add_edit_item';
  final AbstractRepo repo;
  final int? id;
  // final dynamic entity;
   
  @override
  _AddEditItemState createState() => _AddEditItemState();
}


class _AddEditItemState extends State<AddEditItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title;

    bool isAdd = widget.id == null;

    if (isAdd) {
      title = 'Add item';
    }
    else {
      title = 'Edit item';
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: widget.id == null ? Future.value(TestEntity.empty().toJson()) : widget.repo.getById(widget.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ItemForm(
                entity: TestEntity.fromJson(snapshot.data!),
                onSubmit: (Map<String, dynamic> entityMap) async {
                  if (isAdd) {
                    await widget.repo.insert(entityMap);
                  } else {
                    await widget.repo.update(entityMap);
                  }
                  Navigator.pop(context, entityMap);
                },
              );
            }
          },
        ),
      ),
    );
  }
}