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

/// Money label used across the UI.
String formatCost(double value) => '\$${value.toStringAsFixed(2)}';