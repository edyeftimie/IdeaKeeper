import 'package:flutter/material.dart';
//MODIFICATION
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/view/widgets/item_form.dart';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class AddEditItem<T extends Entity> extends StatefulWidget {
  final AbstractRepo<T> repo;
  //MODIFICATION
  final int? id;
  final T Function(Map<String, dynamic> json) fromJson;

  const AddEditItem({Key? key, required this.repo, this.id, required this.fromJson}) : super(key: key);

  @override
  _AddEditItemState<T> createState() => _AddEditItemState<T>();
}

class _AddEditItemState<T extends Entity> extends State<AddEditItem<T>> {
  bool get isAdd => widget.id == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? 'Add Item' : 'Edit Item'),
      ),
      //MODIFICATION
      body: FutureBuilder<T>(
        future: widget.id == null
            //MODIFICATION
            ? Future.value(widget.fromJson({}))
            : widget.repo.getById(widget.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ItemForm(
              entity: snapshot.data!,
              onSubmit: (Map<String, dynamic> entityMap) async {
                //MODIFICATION
                T entity = widget.fromJson(entityMap);
                if (isAdd) {
                  await widget.repo.insert(entity);
                } else {
                  await widget.repo.update(entity);
                }
                Navigator.pop(context, entity.toJson());
              },
            );
          }
        },
      ),
    );
  }
}
