import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dish.dart';
import 'seed_data.dart';

/// Owns the SQLite database and every read/write for foods and order plans.
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
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
    return _db!;
  }

  // Enable foreign keys so deleting a plan or dish also clears its link rows.
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Create the three tables and seed the starting menu (runs once, on install).
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
    await db.execute('''
      CREATE TABLE order_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        target_cost REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE order_plan_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_id INTEGER NOT NULL,
        food_id INTEGER NOT NULL,
        FOREIGN KEY (plan_id) REFERENCES order_plans (id) ON DELETE CASCADE,
        FOREIGN KEY (food_id) REFERENCES food_items (id) ON DELETE CASCADE
      )
    ''');
    for (final food in seedFoods) {
      await db.insert('food_items', food.toMap()..remove('id'));
    }
  }

  // ---------- Food items ----------

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

  // ---------- Order plans ----------

  /// Save a plan and its chosen dishes together in one transaction.
  Future<int> insertPlan(OrderPlan plan) async {
    final db = await database;
    return db.transaction((txn) async {
      final planId = await txn.insert('order_plans', {
        'date': plan.date,
        'target_cost': plan.targetCost,
      });
      for (final item in plan.items) {
        await txn.insert('order_plan_items', {
          'plan_id': planId,
          'food_id': item.id,
        });
      }
      return planId;
    });
  }

  /// Replace a plan's date/budget and rebuild its chosen dishes.
  Future<int> updatePlan(OrderPlan plan) async {
    final db = await database;
    return db.transaction((txn) async {
      final count = await txn.update(
        'order_plans',
        {'date': plan.date, 'target_cost': plan.targetCost},
        where: 'id = ?',
        whereArgs: [plan.id],
      );
      await txn.delete('order_plan_items',
          where: 'plan_id = ?', whereArgs: [plan.id]);
      for (final item in plan.items) {
        await txn.insert('order_plan_items', {
          'plan_id': plan.id,
          'food_id': item.id,
        });
      }
      return count;
    });
  }

  Future<int> deletePlan(int id) async {
    final db = await database;
    return db.delete('order_plans', where: 'id = ?', whereArgs: [id]);
  }

  /// All plans, newest date first.
  Future<List<OrderPlan>> getPlans() async {
    final db = await database;
    final rows = await db.query('order_plans', orderBy: 'date DESC, id DESC');
    final plans = <OrderPlan>[];
    for (final row in rows) {
      plans.add(await _planFromRow(db, row));
    }
    return plans;
  }

  /// The most recent plan saved for a date, or null if none exists.
  Future<OrderPlan?> getPlanByDate(String date) async {
    final db = await database;
    final rows = await db.query('order_plans',
        where: 'date = ?', whereArgs: [date], orderBy: 'id DESC', limit: 1);
    if (rows.isEmpty) return null;
    return _planFromRow(db, rows.first);
  }

  // Attach the chosen dishes to a plan row by joining the link table.
  Future<OrderPlan> _planFromRow(Database db, Map<String, Object?> row) async {
    final itemRows = await db.rawQuery('''
      SELECT f.* FROM food_items f
      INNER JOIN order_plan_items oi ON f.id = oi.food_id
      WHERE oi.plan_id = ?
      ORDER BY f.cost ASC, f.name ASC
    ''', [row['id']]);
    return OrderPlan(
      id: row['id'] as int,
      date: row['date'] as String,
      targetCost: (row['target_cost'] as num).toDouble(),
      items: itemRows.map(Dish.fromMap).toList(),
    );
  }
}
