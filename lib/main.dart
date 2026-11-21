import 'package:material_ui/material_ui.dart';

import 'home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const ReclamationApp());
}

/// Root widget: applies the Reclamation theme and opens the menu.
class ReclamationApp extends StatelessWidget {
  const ReclamationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reclamation',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomeScreen(),
    );
  }
}
