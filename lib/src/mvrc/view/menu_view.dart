import 'package:flutter/material.dart';
import 'package:exam_project/src/mvrc/controller/globals.dart';
import 'package:exam_project/src/mvrc/view/widgets/message.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/list_items');
              },
              child: Text('Registration Section'),
            ),
            ElevatedButton(
              onPressed: () {
                if (isOnline.value == false) {
                  MakeAlertDialog(context, 'No internet connection');
                } else {
                  Navigator.of(context).pushNamed('/genres_list');
                }
              },
              child: Text('Report Section'),
            ),
          ],
        ),
      ),
    );
  }
}