import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'dish.dart';
import 'menu_screen.dart';
import 'new_plan_screen.dart';
import 'theme.dart';

/// Home screen: lists every saved day plan. Tap a plan to edit it, long-press
/// to delete, FAB to add a new one. The top-right button opens the menu items
/// (dishes) screen.
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  List<OrderPlan> _plans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Read the saved plans from the database and refresh the list.
  Future<void> _load() async {
    final plans = await DbHelper.instance.getPlans();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _loading = false;
    });
  }

  Future<void> _newPlan() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NewPlanScreen()),
    );
    if (saved == true) _load();
  }

  Future<void> _editPlan(OrderPlan plan) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NewPlanScreen(plan: plan)),
    );
    if (saved == true) _load();
  }

  Future<void> _confirmDelete(OrderPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete plan?'),
        content: Text('The plan for ${plan.date} will be removed.'),
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
      await DbHelper.instance.deletePlan(plan.id!);
      _load();
    }
  }

  Future<void> _openMenu() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
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
        actions: [
          IconButton(
            tooltip: 'Menu items',
            icon: const Icon(Icons.restaurant_menu),
            onPressed: _openMenu,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(child: _plans.isEmpty ? _buildEmpty() : _buildList()),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newPlan,
        icon: const Icon(Icons.add),
        label: const Text('New plan'),
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
          const Icon(Icons.event, color: kLime),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MEAL PLANS  ·  ${_plans.length} saved',
                    style: const TextStyle(
                        color: kLime, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                const SizedBox(height: 2),
                const Text('Tap a plan to edit · long-press to delete',
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
          const Text('No saved plans yet', style: TextStyle(color: kText, fontSize: 18)),
          const SizedBox(height: 6),
          const Text('Tap "New plan" to create one.', style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 140),
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        final over = plan.total > plan.targetCost;
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _editPlan(plan),
            onLongPress: () => _confirmDelete(plan),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event, color: kLime, size: 20),
                      const SizedBox(width: 8),
                      Text(plan.date,
                          style: const TextStyle(
                              color: kText, fontWeight: FontWeight.w800, fontSize: 16)),
                      const Spacer(),
                      Text(
                        '${formatCost(plan.total)} / ${formatCost(plan.targetCost)}',
                        style: TextStyle(
                            color: over ? kDanger : kOk, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${plan.items.length} dishes',
                      style: const TextStyle(color: kMuted, fontSize: 12)),
                  const SizedBox(height: 10),
                  if (plan.items.isEmpty)
                    const Text('No dishes in this plan.', style: TextStyle(color: kMuted))
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final item in plan.items)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kSurfaceHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(item.name,
                                style: const TextStyle(color: kText, fontSize: 11.5)),
                          ),
                      ],
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