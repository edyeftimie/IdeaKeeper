abstract class Entity {
  int get id;
  set id(int id); 
  Map<String, dynamic> toJson();
  factory Entity.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Entity.fromJson not implemented');
  }
}