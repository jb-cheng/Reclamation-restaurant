import 'package:material_ui/material_ui.dart';

import 'db_helper.dart';
import 'dish.dart';
import 'menu_screen.dart';
import 'new_plan_screen.dart';
import 'theme.dart';

/// Home screen: query a plan by date (found / not found) and list every plan
/// newest-first. Each plan can be edited or deleted. The top-right button
/// opens the menu items screen.
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  List<OrderPlan> _plans = [];
  bool _loading = true;

  DateTime? _queryDate;
  bool _queried = false;
  OrderPlan? _queryResult;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plans = await DbHelper.instance.getPlans();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _loading = false;
    });
  }

  Future<void> _pickQueryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _queryDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _queryDate = picked;
      });
    }
  }

  // Look up the plan saved for the chosen date.
  Future<void> _runQuery() async {
    if (_queryDate == null) return;
    final result = await DbHelper.instance.getPlanByDate(formatDate(_queryDate!));
    if (!mounted) return;
    setState(() {
      _queried = true;
      _queryResult = result;
    });
  }

  // Reset the picked date, the Find button and any found plan.
  void _clearQuery() {
    setState(() {
      _queryDate = null;
      _queried = false;
      _queryResult = null;
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
    if (saved == true) {
      _load();
      if (_queried) _runQuery();
    }
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
      if (_queried) _runQuery();
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
          : ListView(
              padding: const EdgeInsets.only(bottom: 140),
              children: [
                _buildQueryBox(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('MEAL PLANS',
                      style: TextStyle(
                          color: kMuted, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                ),
                if (_plans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text('No saved plans yet.', style: TextStyle(color: kMuted))),
                  )
                else
                  ..._plans.map((plan) => _buildPlanCard(plan)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newPlan,
        icon: const Icon(Icons.add),
        label: const Text('New plan'),
      ),
    );
  }

  Widget _buildQueryBox() {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'FIND A PLAN BY DATE',
                    style: TextStyle(
                        color: kLime, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                  ),
                ),
                TextButton(
                  onPressed: (_queryDate == null && !_queried) ? null : _clearQuery,
                  style: TextButton.styleFrom(
                    foregroundColor: kDanger,
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(0, 0),
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickQueryDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: kSurfaceHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: kLime, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _queryDate == null ? 'Pick a date' : formatDate(_queryDate!),
                            style: TextStyle(color: _queryDate == null ? kMuted : kText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _queryDate == null ? null : _runQuery,
                  child: const Text('Find'),
                ),
              ],
            ),
            if (_queried) ...[
              const SizedBox(height: 12),
              if (_queryResult == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kSurfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kDanger.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_off, color: kDanger, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('No plan found for ${formatDate(_queryDate!)}.',
                            style: const TextStyle(color: kText)),
                      ),
                    ],
                  ),
                )
              else
                _buildPlanCard(_queryResult!, highlight: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(OrderPlan plan, {bool highlight = false}) {
    final over = plan.total > plan.targetCost;
    return Card(
      margin: highlight ? EdgeInsets.zero : null,
      shape: highlight
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: kLime, width: 1.5),
            )
          : null,
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
                IconButton(
                  tooltip: 'Edit plan',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit, size: 20, color: kMuted),
                  onPressed: () => _editPlan(plan),
                ),
                IconButton(
                  tooltip: 'Delete plan',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline, size: 20, color: kDanger),
                  onPressed: () => _confirmDelete(plan),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${plan.items.length} dishes',
                    style: const TextStyle(color: kMuted, fontSize: 12)),
                const Spacer(),
                Text(
                  '${formatCost(plan.total)} / ${formatCost(plan.targetCost)}',
                  style: TextStyle(color: over ? kDanger : kOk, fontWeight: FontWeight.w800),
                ),
              ],
            ),
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
    );
  }
}
