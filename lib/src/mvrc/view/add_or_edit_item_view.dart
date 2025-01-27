import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/model/test_entity.dart';
//MODIFICATION
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/view/widgets/item_form.dart';

class AddEditItem extends StatefulWidget {
  final AbstractRepo<TestEntity> repo;
  //MODIFICATION
  final int? id;

  const AddEditItem({Key? key, required this.repo, this.id}) : super(key: key);

  @override
  _AddEditItemState createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {
  bool get isAdd => widget.id == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? 'Add Item' : 'Edit Item'),
      ),
      //MODIFICATION
      body: FutureBuilder<TestEntity>(
        future: widget.id == null
            //MODIFICATION
            ? Future.value(TestEntity.empty())
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
                TestEntity entity = TestEntity.fromJson(entityMap);
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
