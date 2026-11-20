import 'package:material_ui/material_ui.dart';
import 'new_dish_screen.dart';
import 'dish.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Dish> _dishes = [];

  @override
  void initState() {
    super.initState();
    debugPrint('Home initState');
  }

  Future<void> _openNewDish() async {
    final result = await Navigator.push<Dish>(
      context,
      MaterialPageRoute(builder: (context) => const NewDishScreen()),
    );
    debugPrint('result: ${result?.name}');
    if (result != null) {
      setState(() {
        _dishes.add(result);
      });
    }
  }

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete dish?'),
        content: Text('${_dishes[index].name} will be removed.'),
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
    debugPrint('confirmed: $confirmed');
    if (confirmed == true) {
      setState(() {
        _dishes.removeAt(index);
      });
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
      body: _dishes.isEmpty ? _buildEmpty() : _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewDish,
        child: const Icon(Icons.add),
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
          const Text('No dishes yet', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _dishes.length,
      itemBuilder: (context, index) {
        final dish = _dishes[index];
        return GestureDetector(
          onLongPress: () => _confirmDelete(index),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kText,
                    ),
                  ),
                  if (dish.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(dish.description, style: const TextStyle(color: kMuted)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}