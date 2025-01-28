import 'package:exam_project/src/mvrc/model/abstract_entity.dart';
// import 'package:flutter/material.dart';

class Book implements Entity {
  @override
  int id;
  String title;
  String author;
  String genre;
  int year;
  String isbn;
  String availability;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.year,
    required this.isbn,
    required this.availability,
  });

  Book.empty():
    id = -1,
    title = '',
    author = '',
    genre = '',
    year = 0,
    isbn = '',
    availability = '';
  
  factory Book.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Book.empty();
    }
    // int id;
    // if (json['id'] is int) {
    //   id = json['id'];
    // } else {
    //   id = int.parse(json['id']);
    //   if (id == 0) {
    //     id = -1;
    //   }
    // }
    // debugPrint ('Book.fromJson: id = $id');
    // debugPrint ('Book fromJson: json = $json');
    Book book = Book(
      id: json['id'] is int? json['id'] : int.parse(json['id']),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      year: json['year'] is int? json['year'] : int.parse(json['year']),
      isbn: json['ISBN'] ?? '',
      availability: json['availability'] ?? '',
    );
    // debugPrint ('Book.fromJson: book = $book');
    return book;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'year': year,
      'ISBN': isbn,
      'availability': availability,
    };
  }
}