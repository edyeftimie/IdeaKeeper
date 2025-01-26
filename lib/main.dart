import 'package:flutter/material.dart';

import 'package:exam_project/src/app.dart';
import 'package:exam_project/src/mvrc/model/test_entity.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TestEntity testEntity = TestEntity(
    id: '2',
    name: 'Test Entity 2',
    description: 'This is a test entity',
    imageUrl: 'https://example.com/image.jpg',
  );

  final AbstractRepo repo = AbstractRepo(testEntity);
  await repo.database;
  // Map<String, dynamic> entityMap = testEntity.toJson();
  // await repo.insert(entityMap);

  runApp(MyApp(repo: repo));
}
