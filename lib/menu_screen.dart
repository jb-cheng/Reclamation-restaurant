import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'new_dish_screen.dart';
import 'dish.dart';
import 'theme.dart';

/// Menu items screen: the seeded menu of dishes with their costs.
/// Tap a dish to edit it, long-press to delete, FAB to add a new one.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Dish> _foods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Read the menu from the database and refresh the list.
  Future<void> _load() async {
    final foods = await DbHelper.instance.getFoods();
    if (!mounted) return;
    setState(() {
      _foods = foods;
      _loading = false;
    });
  }

  Future<void> _openFoodForm({Dish? food}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NewDishScreen(food: food)),
    );
    if (saved == true) _load();
  }

  Future<void> _confirmDelete(Dish food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete dish?'),
        content: Text('${food.name} will be removed from the menu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: kDanger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DbHelper.instance.deleteFood(food.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MENU ITEMS')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _foods.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildList()),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFoodForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add dish'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2E16), kSurface],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: kLime.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu, color: kLime),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROVISIONS  ·  ${_foods.length} dishes',
                    style: const TextStyle(
                        color: kLime, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                const SizedBox(height: 2),
                const Text('Tap a dish to edit · long-press to delete',
                    style: TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo.png', width: 120),
          const SizedBox(height: 16),
          const Text('No dishes yet', style: TextStyle(color: kText, fontSize: 18)),
          const SizedBox(height: 6),
          const Text('Tap "Add dish" to create one.', style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 140),
      itemCount: _foods.length,
      itemBuilder: (context, index) {
        final food = _foods[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _openFoodForm(food: food),
            onLongPress: () => _confirmDelete(food),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kSurfaceHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: food.image.isEmpty
                        ? const Icon(Icons.restaurant, color: kMuted, size: 30)
                        : Image.asset(
                            food.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.restaurant, color: kMuted),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name,
                            style: const TextStyle(
                                color: kText, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(food.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: kMuted, fontSize: 12.5, height: 1.3)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kLime.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kLime.withValues(alpha: 0.5)),
                    ),
                    child: Text(formatCost(food.cost),
                        style: const TextStyle(color: kLime, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}