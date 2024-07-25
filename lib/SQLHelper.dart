import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        author TEXT,
        published_time TEXT,
        genre TEXT,
        image TEXT
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'library.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title,
      String description,
      String author,
      String publishedTime,
      String genre,
      String image,
      ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'author': author,
      'published_time': publishedTime,
      'genre': genre,
      'image': image,
    };

    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }


  // Read all items
  static Future<List<Map<String, dynamic>>> getItems({String? searchQuery, String? orderBy}) async {
    final db = await SQLHelper.db();
    String query = 'SELECT * FROM items';
    List<dynamic> args = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query += ' WHERE title LIKE ? OR author LIKE ?';
      args.add('%$searchQuery%');
      args.add('%$searchQuery%');
    }

    if (orderBy != null && orderBy.isNotEmpty) {
      query += ' ORDER BY $orderBy';
    }

    debugPrint('Executing query: $query with args: $args');
    return db.rawQuery(query, args);
  }

  // Read a single item by id
  static Future<Map<String, dynamic>?> getItem(int id) async {
    final db = await SQLHelper.db();
    final result = await db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String title,
      String description,
      String author,
      String publishedTime,
      String genre,
      String image,
      ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'author': author,
      'published_time': publishedTime,
      'genre': genre,
      'image': image,
    };

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete an item by id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
