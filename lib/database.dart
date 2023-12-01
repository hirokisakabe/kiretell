import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'ShoppingItems_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE ShoppingItems(id String PRIMARY KEY, name TEXT, needToBuy BOOLEAN)',
      );
    },
    version: 1,
  );
}
