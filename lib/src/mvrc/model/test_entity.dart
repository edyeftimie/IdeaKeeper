class TestEntity {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

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
    return TestEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}