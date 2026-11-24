// Plain data models shared by the database layer and the UI.

/// A single dish on the Reclamation menu (one row of the food_items table).
class Dish {
  final int? id;
  final String name;
  final double cost;
  final String description;
  final String image; // asset path of the dish icon

  const Dish({
    this.id,
    required this.name,
    this.cost = 0.0,
    required this.description,
    this.image = '',
  });

  /// Row representation used by sqflite insert/update.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'description': description,
      'image': image,
    };
  }

  /// Rebuild a Dish from a database row.
  factory Dish.fromMap(Map<String, Object?> map) {
    return Dish(
      id: map['id'] as int?,
      name: map['name'] as String,
      cost: (map['cost'] as num).toDouble(),
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }
}

/// A saved day plan: a date, a budget, and the dishes chosen for that day.
class OrderPlan {
  final int? id;
  final String date; // stored as yyyy-MM-dd
  final double targetCost;
  final List<Dish> items;

  const OrderPlan({
    this.id,
    required this.date,
    required this.targetCost,
    required this.items,
  });

  /// Sum of the chosen dishes; kept at or below targetCost.
  double get total => items.fold(0.0, (sum, item) => sum + item.cost);
}

/// Format a date the same way it is stored in the database (yyyy-MM-dd).
String formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// Money label used across the UI.
String formatCost(double value) => '\$${value.toStringAsFixed(2)}';