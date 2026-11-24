import 'package:material_ui/material_ui.dart';

import 'plans_screen.dart';
import 'theme.dart';

void main() {
  runApp(const ReclamationApp());
}

/// Root widget: applies the Reclamation theme and opens the order plans.
class ReclamationApp extends StatelessWidget {
  const ReclamationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reclamation',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const PlansScreen(),
    );
  }
}
