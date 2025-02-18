import 'package:exam_project/src/mvrc/controller/controller.dart';
import 'package:flutter/material.dart';
//MODIFICATION
import 'package:exam_project/src/mvrc/view/widgets/item_form.dart';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class AddEditItem<T extends Entity> extends StatefulWidget {
  // final AbstractRepo<T> repo;
  final Controller<T> controller;
  //MODIFICATION
  final int? id;
  final T Function(Map<String, dynamic> json) fromJson;

  // const AddEditItem({Key? key, required this.repo, this.id, required this.fromJson}) : super(key: key);
  const AddEditItem({Key? key, required this.controller, this.id, required this.fromJson}) : super(key: key);

  @override
  _AddEditItemState<T> createState() => _AddEditItemState<T>();
}

class _AddEditItemState<T extends Entity> extends State<AddEditItem<T>> {
  bool get isAdd => widget.id == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? 'Add Item' : 'View details'),
      ),
      //MODIFICATION
      body: FutureBuilder<T>(
        future: widget.id == null
            //MODIFICATION
            ? Future.value(widget.fromJson({}))
            // : widget.repo.getById(widget.id!),
            : widget.controller.getEntityById(widget.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (isAdd) {
            return ItemForm(
              entity: snapshot.data!,
              onSubmit: (Map<String, dynamic> entityMap) async {
                //MODIFICATION
                T entity = widget.fromJson(entityMap);
                if (isAdd) {
                  // await widget.repo.insert(entity, null);
                  await widget.controller.addEntity(context, entity);
                }
                // } else {
                  // await widget.controller.getEntityById(entity.id);
                //   // await widget.repo.update(entity);
                //   await widget.controller.updateEntity(entity);
                // }
                Navigator.pop(context, entity.toJson());
              },
            );
          } else {
            T entity = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${entity.id}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Date: ${entity.toJson()['date']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Amount: ${entity.toJson()['amount']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Type: ${entity.toJson()['type']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Category: ${entity.toJson()['category']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Description: ${entity.toJson()['description']}', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
