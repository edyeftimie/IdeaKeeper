import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class Transaction implements Entity {
  @override
  int id;
  String date;
  double amount;
  String type;
  String category;
  String description;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
  });

  Transaction.empty():
    id = -1,
    date = '',
    amount = 0.0,
    type = '',
    category = '',
    description = '';

  factory Transaction.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Transaction.empty();
    }
    Transaction transaction = Transaction(
      id: json['id'] is int? json['id'] : int.parse(json['id']),
      date: json['date'] ?? '',
      amount: json['amount'] is double? json['amount'] : double.parse(json['amount']),
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
    return transaction;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
    };
  }
}
