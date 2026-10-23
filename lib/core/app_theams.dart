import 'package:flutter/material.dart';
import '../local_Store/local_store.dart';

class AppTheme {
  AppTheme._();

  // Teal Color Palette
  static const Color lightIceTeal = Color(0xFFA5E6E2); // #A5E6E2 (Ice Teal Accent)
  static const Color softMintTeal = Color(0xFF77DAD7); // #77DAD7
  static const Color vibrantTeal = Color(0xFF36B8B7);  // #36B8B7
  static const Color darkTeal = Color(0xFF0A858C);     // #0A858C
  static const Color deepTeal = Color(0xFF0B757B);     // #0B757B (Dark Mode Primary)
  static const Color pureWhite = Color(0xFFFFFFFF);    // #FFFFFF (Light Mode Primary Background)
  static const Color darkNavy = Color(0xFF12345A);     // #12345A (Light Mode High Contrast Text)

  // Dynamic Theme Controller
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static bool get isDark => themeModeNotifier.value == ThemeMode.dark;

  static void initTheme() {
    final isDarkMode = LocalStore.instance.getIsDarkMode();
    themeModeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    await LocalStore.instance.setIsDarkMode(mode == ThemeMode.dark);
  }

  // Adaptive Styling Helpers for Light (Full White) vs Dark Mode
  static BoxDecoration glassDecoration({
    double opacity = 0.18,
    double borderOpacity = 0.28,
    double radius = 22,
  }) {
    final dark = isDark;
    return BoxDecoration(
      color: dark
          ? Colors.white.withValues(alpha: opacity)
          : Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: dark
            ? Colors.white.withValues(alpha: borderOpacity)
            : const Color(0xFFE2E8F0),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: dark
              ? Colors.black.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration screenBackgroundGradient({bool? isDarkMode}) {
    final dark = isDarkMode ?? isDark;
    if (dark) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D8188),
            Color(0xFF0B757B), // deepTeal
            Color(0xFF075459),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      // Full White Light Mode Background Gradient
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF), // Pure White
            Color(0xFFF8FAFC),
            Color(0xFFF1F5F9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
  }

  // Light Theme (Full White Background + Opposite High Contrast Typography)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: pureWhite,
      colorScheme: const ColorScheme.light(
        primary: darkTeal,
        secondary: vibrantTeal,
        surface: pureWhite,
        onPrimary: pureWhite,
        onSurface: darkNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pureWhite,
        foregroundColor: darkNavy,
        elevation: 0,
        iconTheme: IconThemeData(color: darkNavy),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkTeal,
          foregroundColor: pureWhite,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // Dark Theme (Deep Teal Background + Light Typography & Accents)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepTeal,
      colorScheme: const ColorScheme.dark(
        primary: vibrantTeal,
        secondary: lightIceTeal,
        surface: deepTeal,
        onPrimary: pureWhite,
        onSurface: pureWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: pureWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: pureWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantTeal,
          foregroundColor: pureWhite,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
