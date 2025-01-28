import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:exam_project/src/mvrc/controller/web_socket_controller.dart';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class ServerController <T extends Entity> {
  final String baseUrl;
  late WebSocketController _webSocketController;
  final T Function(Map<String, dynamic> json) fromJson;
  final String add = 'book';
  final String update = 'book';
  final String delete = 'book';
  final String getById = 'book';
  final String url = 'ws://localhost:2419';

  ServerController({required this.baseUrl, required Function onReconnect, required this.fromJson}) {
    _webSocketController = WebSocketController(url: url, onReconnect: onReconnect);
  }

  Future<List<T>> fetchItems() async {
    //MODIFICATION
    final response = await http.get(Uri.parse('$baseUrl/all'));
    if (response.statusCode == 200) {
      debugPrint ( 'serverController: fetchItems response 200' );
      debugPrint ( response.body );
      List<dynamic> data = json.decode(response.body);
      debugPrint ("serverController: fetchItems data");
      debugPrint (data.toString());

      List<T> items = [];
      for (var item in data) {
        items.add(fromJson(item));
      }
      debugPrint (items.toString());
      return data.map((item) => fromJson(item)).toList();
    } else {
      debugPrint ( 'serverController: fetchItems response not 200' );
      throw Exception('ERROR serverController: Failed to load activities');
    }
  }

  Future<T> addEntity(T entity) async {
    final response = await http.post(
      //MODIFICATION
      Uri.parse('$baseUrl/$add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entity.toJson()),
    );

    //log the body of the request
    debugPrint(json.encode(entity.toJson()));
    debugPrint(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to add activity');
    }

    sendWebSocketMessage('New activity added');
    debugPrint ('serverController: addEntity response 200');
    return fromJson(json.decode(response.body));
  }

  Future<void> updateEntity(T entity) async {
    final response = await http.put(
      //MODIFICATION
      Uri.parse('$baseUrl/$update/${entity.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entity.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update activity');
    }
  }

  Future<void> deleteEntity(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }

  Future<T> getEntityById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$getById/$id'));

    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Stream get WebSocketStream => _webSocketController.stream;

  void sendWebSocketMessage(String message) {
    _webSocketController.send(message);
  }

  void closeWebSocket() {
    _webSocketController.close();
  }
}