import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'dish.dart';
import 'new_dish_screen.dart';
import 'theme.dart';

/// Home screen: the seeded menu of dishes with their costs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> _openNewDish() async {
    final dish = await Navigator.push<Dish>(
      context,
      MaterialPageRoute(builder: (context) => const NewDishScreen()),
    );
    if (dish == null) return;
    // The unchanged add form has no cost field, so new dishes start at $0.00.
    await DbHelper.instance.insertFood(Dish(
      name: dish.name,
      cost: 0.0,
      description: dish.description,
      image: '',
    ));
    _load();
  }

  Future<void> _confirmDelete(Dish food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete dish?'),
        content: Text('${food.name} will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 26),
            const SizedBox(width: 10),
            const Text('RECLAMATION'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewDish,
        icon: const Icon(Icons.add),
        label: const Text('Add dish'),
      ),
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
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 96),
      itemCount: _foods.length,
      itemBuilder: (context, index) {
        final food = _foods[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
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
