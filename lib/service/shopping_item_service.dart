import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../config/database.dart';
import '../model/shopping_item.dart';

class ShoppingItemService {
  late Future<Database> database;

  Future<void> initialize() async {
    database = initDatabase();
  }

  Future<void> insertShoppingItem(ShoppingItem shoppingItem) async {
    final db = await database;

    await db.insert(
      'ShoppingItems',
      shoppingItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ShoppingItem>> fetchShoppingItems() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('ShoppingItems');

    bool intToBool(int a) => a == 0 ? false : true;

    return List.generate(maps.length, (i) {
      return ShoppingItem(
        id: maps[i]['id'] as String,
        name: maps[i]['name'] as String,
        needToBuy: intToBool(maps[i]['needToBuy']),
      );
    });
  }

  Future<void> updateShoppingItem(ShoppingItem shoppingItem) async {
    final db = await database;

    await db.update(
      'ShoppingItems',
      shoppingItem.toMap(),
      where: 'id = ?',
      whereArgs: [shoppingItem.id],
    );
  }

  Future<void> updateShoppingItemToBuy(String id, bool toBuy) async {
    final db = await database;

    await db.update(
      'ShoppingItems',
      {
        'needToBuy': toBuy,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteShoppingItem(String itemId) async {
    final db = await database;

    await db.delete(
      'ShoppingItems',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }
}
