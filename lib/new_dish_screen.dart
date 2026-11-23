import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'dish.dart';

/// Add a new dish (food == null) or edit an existing one.
/// Pops with `true` when a dish was saved so the menu can reload.
class NewDishScreen extends StatefulWidget {
  final Dish? food;
  const NewDishScreen({super.key, this.food});

  @override
  State<NewDishScreen> createState() => _NewDishScreenState();
}

class _NewDishScreenState extends State<NewDishScreen> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _descController = TextEditingController();
  String? _nameError;
  String? _costError;

  bool get _isEdit => widget.food != null;

  @override
  void initState() {
    super.initState();
    final food = widget.food;
    if (food != null) {
      _nameController.text = food.name;
      _costController.text = food.cost.toStringAsFixed(2);
      _descController.text = food.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Validate the inputs, then insert or update the dish.
  Future<void> _save() async {
    final name = _nameController.text.trim();
    final cost = double.tryParse(_costController.text.trim());
    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _costError = (cost == null || cost <= 0) ? 'Enter a cost greater than 0' : null;
    });
    if (_nameError != null || _costError != null) return;

    final existing = widget.food;
    final food = Dish(
      id: existing?.id,
      name: name,
      cost: cost!,
      description: _descController.text.trim(),
      image: existing?.image ?? '',
    );
    if (_isEdit) {
      await DbHelper.instance.updateFood(food);
    } else {
      await DbHelper.instance.insertFood(food);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'EDIT DISH' : 'ADD DISH')),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
            controller: _costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Cost',
              prefixText: '\$ ',
              border: const OutlineInputBorder(),
              errorText: _costError,
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
            onPressed: _save,
            child: Text(_isEdit ? 'Save changes' : 'Add dish'),
          ),
        ],
      ),
    );
  }
}
