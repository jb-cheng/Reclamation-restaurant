import 'package:material_ui/material_ui.dart';

// Reclamation palette: acid lime-yellow on desert charcoal, taken from the
// Reclamation Algorithm key art. Kept in one place so every screen matches.
const Color kLime = Color(0xFFCDDC39); // signature greenish-yellow accent
const Color kCharcoal = Color(0xFF15161A); // page background
const Color kSurface = Color(0xFF212228); // cards
const Color kSurfaceHigh = Color(0xFF2C2E36); // fields, chips
const Color kInk = Color(0xFF1A1B10); // text/icons on lime
const Color kText = Color(0xFFEDEEE6); // primary text
const Color kMuted = Color(0xFFA7AA9C); // secondary text
const Color kDanger = Color(0xFFFF6B6B); // over budget / delete
const Color kOk = Color(0xFF9CCC65); // within budget

/// Build the app-wide dark theme from the palette above.
ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: kLime,
    onPrimary: kInk,
    secondary: kLime,
    onSecondary: kInk,
    surface: kSurface,
    onSurface: kText,
    error: kDanger,
    onError: Color(0xFF2A0000),
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: kCharcoal,
    appBarTheme: const AppBarThemeData(
      backgroundColor: kCharcoal,
      foregroundColor: kLime,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: kLime,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kLime,
      foregroundColor: kInk,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kLime,
        foregroundColor: kInk,
        disabledBackgroundColor: kSurfaceHigh,
        disabledForegroundColor: kMuted,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: kSurfaceHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kLime, width: 1.5),
      ),
      labelStyle: const TextStyle(color: kMuted),
      hintStyle: const TextStyle(color: kMuted),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? kLime : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(kInk),
      side: const BorderSide(color: kMuted, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: kSurface,
      titleTextStyle: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w700),
      contentTextStyle: TextStyle(color: kMuted),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kSurfaceHigh,
      contentTextStyle: TextStyle(color: kText),
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: kLime),
    dividerColor: kSurfaceHigh,
  );
}