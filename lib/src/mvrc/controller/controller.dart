import 'package:flutter/material.dart';

import 'package:exam_project/src/mvrc/controller/globals.dart';
import 'package:exam_project/src/mvrc/controller/server_controller.dart';
import 'package:exam_project/src/mvrc/repository/abstract_repo.dart';
import 'package:exam_project/src/mvrc/model/abstract_entity.dart';

class Controller<T extends Entity> {
  final ServerController<T> serverController;
  final AbstractRepo<T> repo;

  Controller({required this.serverController, required this.repo});

  Future<void> initDatabase(BuildContext context) async {
    try{
      await repo.database;
      debugPrint ( "Controller: init db" );
      await SyncItemsFromServer(context); 
    } catch (e) {
      debugPrint( "ERROR controller: init db from server $e" );
    }
  }

  Future<List<Map<String, dynamic>>> SyncItemsFromServer(BuildContext context) async {
    debugPrint ( "SyncItemsFromServer" );
    final items = await serverController.fetchItems(context);
    debugPrint ( "SyncItemsFromServer: fetched items" );
    items.forEach((item) async {
      // debugPrint ( "SyncItemsFromServer: insert item" );
      await repo.insert(item, item.id);
    });
    // debugPrint ( "SyncItemsFromServer: return items finished" );
    List<Map<String, dynamic>> itemsJson = [];
    for (var item in items) {
      // debugPrint ( "SyncItemsFromServer: add item to itemsJson" );
      itemsJson.add(item.toJson());
      // debugPrint (item.toJson().toString());
    }
    debugPrint ( "SyncItemsFromServer: return itemsJson" );
    return items.map((item) => item.toJson()).toList();
  }

  Future<int> addEntity(BuildContext context, T entity) async {
    T newEntity = entity;
    if (isOnline.value == true) {
      try {
        newEntity = await serverController.addEntity(context, entity);
        debugPrint( "Controller: addEntity on server" );
      } catch (e) {
        debugPrint( "ERROR controller: addEntity on server $e" );
      }
      await repo.insert(newEntity, newEntity.id);
      return newEntity.id;
    } else {
      debugPrint ( "Controller: addEntity offline" );
      await repo.insert(newEntity, null);
      return newEntity.id;
    }
  }

  // Future<void> updateEntity(T entity) async {
  //   if (isOnline.value == true) {
  //     try {
  //       debugPrint ( "Controller: updateEntity on server" );
  //       await serverController.updateEntity(entity);
  //       debugPrint ( "Controller: updateEntity on server finished" );
  //     } catch (e) {
  //       debugPrint( "ERROR controller: updateEntity on server $e" );
  //     }
  //   } else {
  //     debugPrint ( "Controller: updateEntity offline" );
  //   }
  //   await repo.update(entity);
  // }

  Future<void> deleteEntity(int id) async {
    if (isOnline.value == true) {
      try {
        debugPrint ( "Controller: deleteEntity on server" );
        await serverController.deleteEntity(id);
        debugPrint ("i deleted the entity from the server");
      } catch (e) {
        debugPrint( "ERROR controller: deleteEntity on server $e" );
      }
    }
    await repo.delete(id);
  }

  Future<T> getEntityById(int id) async {
    T entity = await repo.getById(id);
    if (isOnline.value == true) {
      try {
        entity = await serverController.getEntityById(id);
      } catch (e) {
        debugPrint( "ERROR controller: getEntityById on server $e" );
      }
    }
    return entity;
  }
}