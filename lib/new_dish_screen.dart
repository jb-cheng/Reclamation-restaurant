import 'package:material_ui/material_ui.dart';
import 'dish.dart';

class NewDishScreen extends StatefulWidget {
  const NewDishScreen({super.key});

  @override
  State<NewDishScreen> createState() => _NewDishScreenState();
}

class _NewDishScreenState extends State<NewDishScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String? _nameError;

  @override
  void initState() {
    super.initState();
    debugPrint('NewDish initState');
  }

  @override
  void dispose() {
    debugPrint('NewDish dispose');
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _done() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      return;
    }
    final dish = Dish(
      name: name,
      description: _descController.text.trim(),
    );
    Navigator.pop(context, dish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Dish')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: const OutlineInputBorder(),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _done,
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}