import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

/// The local database of Agora. Contains references to what items are in the favorites list. This
/// allows state to persist for favorites. 
class AgoraLocal {
  static Database? _database; 

  /// Gets the reference to the database. If there is a reference return that otherwise create a database.
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await createDatabase();
    return _database!;
  } 

  /// Creates the database with the table for favorites
  /// favorites table has two things: id Integer Primary Key and type Text
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

  /// Inserts a reference to a favorite item into the table
  static Future<void> insertFavorite(int id, String type) async {
    final db = await database;

    await db.insert(
      'favorites',
      {'id': id, 'type': type},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  /// Removes a reference to a favorite item from the table
  static Future<void> removeFavorite(int id) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: "id = ?",
      whereArgs: [id]
    );
  }

  /// Returns a list of every relation (via a map) from the favorites table. 
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;

    return await db.query('favorites');
  }


}