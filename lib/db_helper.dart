import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dish.dart';
import 'seed_data.dart';

/// Owns the SQLite database and every read/write for the menu.
/// A singleton so the whole app shares one open connection.
class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const String _dbName = 'reclamation.db';
  static const int _dbVersion = 1;

  Database? _db;

  /// Open the database once, then reuse the same connection.
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
    return _db!;
  }

  // Create the menu table and seed the starting dishes (runs once, on install).
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
    for (final food in seedFoods) {
      await db.insert('food_items', food.toMap()..remove('id'));
    }
  }

  /// All dishes, cheapest first.
  Future<List<Dish>> getFoods() async {
    final db = await database;
    final rows = await db.query('food_items', orderBy: 'cost ASC, name ASC');
    return rows.map(Dish.fromMap).toList();
  }

  Future<int> insertFood(Dish food) async {
    final db = await database;
    return db.insert('food_items', food.toMap()..remove('id'));
  }

  Future<int> updateFood(Dish food) async {
    final db = await database;
    return db.update('food_items', food.toMap(),
        where: 'id = ?', whereArgs: [food.id]);
  }

  Future<int> deleteFood(int id) async {
    final db = await database;
    return db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }
}
