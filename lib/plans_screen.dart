import 'package:material_ui/material_ui.dart';

import 'dish.dart';
import 'menu_screen.dart';
import 'new_plan_screen.dart';
import 'theme.dart';

/// Home screen: the meal plans. For now the list is not wired to the database
/// yet, so it stays empty; the FAB opens the plan builder which saves into the
/// database. The top-right button opens the menu items (dishes) screen.
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final List<OrderPlan> _plans = [];

  Future<void> _newPlan() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NewPlanScreen()),
    );
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
      body: Column(
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
                const Text('MEAL PLANS',
                    style: TextStyle(
                        color: kLime, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                const SizedBox(height: 2),
                const Text('Tap "New plan" to build a day.',
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
          const Text('Plans you save will appear here.', style: TextStyle(color: kMuted)),
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
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(plan.date, style: const TextStyle(color: kText)),
          ),
        );
      },
    );
  }
}