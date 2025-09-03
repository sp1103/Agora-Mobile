import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class AgoraLocal {
  static Database? _database; 

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await createDatabase();
    return _database!;
  } 

  static Future<Database> createDatabase() async {

    return openDatabase(

      join(await getDatabasesPath(), "agora_mobile_database.db"),

      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY, type TEXT)'
        );
      },

      version: 1,

    );
  }

  static Future<void> insertFavorite(int id, String type) async {
    final db = await database;

    await db.insert(
      'favorites',
      {'id': id, 'type': type},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<void> removeFavorite(int id) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: "id = ?",
      whereArgs: [id]
    );
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;

    return await db.query('favorites');
  }


}