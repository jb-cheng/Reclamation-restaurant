import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'dish.dart';
import 'theme.dart';

/// Build a day plan: set a target cost, pick a date, and choose dishes whose
/// total stays at or below the target. Also used to edit an existing plan.
class NewPlanScreen extends StatefulWidget {
  final OrderPlan? plan;
  const NewPlanScreen({super.key, this.plan});

  @override
  State<NewPlanScreen> createState() => _NewPlanScreenState();
}

class _NewPlanScreenState extends State<NewPlanScreen> {
  final _targetController = TextEditingController();
  DateTime? _date;
  List<Dish> _foods = [];
  final Set<int> _selected = {}; // ids of the chosen dishes
  bool _loading = true;
  String? _targetError;

  bool get _isEdit => widget.plan != null;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    if (plan != null) {
      _targetController.text = plan.targetCost.toStringAsFixed(2);
      _date = DateTime.parse(plan.date);
      _selected.addAll(plan.items.map((f) => f.id!));
    }
    _load();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final foods = await DbHelper.instance.getFoods();
    if (!mounted) return;
    setState(() {
      _foods = foods;
      _loading = false;
    });
  }

  double get _target => double.tryParse(_targetController.text.trim()) ?? 0;

  double get _total {
    double sum = 0;
    for (final food in _foods) {
      if (_selected.contains(food.id)) sum += food.cost;
    }
    return sum;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  // Toggle a dish; refuse to add it if it would push the total over the target.
  void _toggle(Dish food, bool? checked) {
    final id = food.id!;
    if (checked == true) {
      if (_total + food.cost > _target) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Over budget: ${food.name} (${formatCost(food.cost)}) would exceed ${formatCost(_target)}.'),
          ),
        );
        return;
      }
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
    setState(() {});
  }

  bool get _canSave =>
      _date != null && _target > 0 && _selected.isNotEmpty && _total <= _target;

  Future<void> _save() async {
    final target = double.tryParse(_targetController.text.trim());
    setState(() {
      _targetError = (target == null || target <= 0) ? 'Enter a target greater than 0' : null;
    });
    if (_targetError != null || _date == null || _selected.isEmpty) return;

    final items = _foods.where((f) => _selected.contains(f.id)).toList();
    final plan = OrderPlan(
      id: widget.plan?.id,
      date: formatDate(_date!),
      targetCost: target!,
      items: items,
    );
    if (_isEdit) {
      await DbHelper.instance.updatePlan(plan);
    } else {
      await DbHelper.instance.insertPlan(plan);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'EDIT PLAN' : 'NEW PLAN')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildControls(),
                _buildBudgetBar(),
                const Divider(height: 1),
                Expanded(child: _buildFoodPicker()),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            onPressed: _canSave ? _save : null,
            child: const Text('Save plan'),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          TextField(
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Target cost per day',
              prefixText: '\$ ',
              errorText: _targetError,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: kSurfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: kLime),
                  const SizedBox(width: 12),
                  Text(
                    _date == null ? 'Pick a date' : formatDate(_date!),
                    style: TextStyle(color: _date == null ? kMuted : kText, fontSize: 15),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: kMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBar() {
    final target = _target;
    final total = _total;
    final over = total > target && target > 0;
    final double frac = target > 0 ? (total / target).clamp(0.0, 1.0).toDouble() : 0.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${_selected.length} selected',
                  style: const TextStyle(color: kMuted, fontSize: 12)),
              const Spacer(),
              Text(
                '${formatCost(total)} / ${target > 0 ? formatCost(target) : "--"}',
                style: TextStyle(color: over ? kDanger : kOk, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: frac,
              minHeight: 8,
              backgroundColor: kSurfaceHigh,
              valueColor: AlwaysStoppedAnimation(over ? kDanger : kLime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPicker() {
    if (_foods.isEmpty) {
      return const Center(
        child: Text('No dishes on the menu. Add some first.',
            style: TextStyle(color: kMuted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: _foods.length,
      itemBuilder: (context, index) {
        final food = _foods[index];
        final checked = _selected.contains(food.id);
        return CheckboxListTile(
          value: checked,
          onChanged: (value) => _toggle(food, value),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(food.name,
              style: const TextStyle(
                  color: kText, fontWeight: FontWeight.w600, fontSize: 14.5)),
          subtitle: Text(formatCost(food.cost),
              style: const TextStyle(color: kLime, fontWeight: FontWeight.w700)),
          secondary: SizedBox(
            width: 44,
            height: 44,
            child: food.image.isEmpty
                ? const Icon(Icons.restaurant, color: kMuted)
                : Image.asset(food.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, color: kMuted)),
          ),
        );
      },
    );
  }
}
