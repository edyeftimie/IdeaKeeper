import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class TestEntity implements Entity {
  @override
  int id;
  String name;
  String description;
  String imageUrl;

  TestEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  TestEntity.empty():
    id = -1,
    name = '',
    description = '',
    imageUrl = '';

  factory TestEntity.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return TestEntity.empty();
    }
    return TestEntity(
      id: json['id'] ?? -1,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}