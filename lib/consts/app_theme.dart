import 'package:flutter/material.dart';
import 'colors.dart';

// ────────────────────────────────────────────────────────────────────────────
//  COMFI APP THEME
//  Usage in main.dart:
//    theme:      AppTheme.light,
//    darkTheme:  AppTheme.dark,
//    themeMode:  ThemeMode.system,   ← follows device setting automatically
// ────────────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  // ── SHARED ────────────────────────────────────────────────────────────────

  static const _fontFamily = 'Poppins'; // swap to any font in your pubspec

  static const _accentGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── DARK THEME ────────────────────────────────────────────────────────────

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    useMaterial3: true,

    // Seeds the M3 color system — overrides below take precedence
    colorScheme: const ColorScheme.dark(
      primary:          kViolet,
      onPrimary:        Colors.white,
      secondary:        kAccent,
      onSecondary:      Colors.black,
      tertiary:         kHighlight,
      surface:          kDarkSurface,
      onSurface:        Colors.white,
      surfaceContainerHighest: kDarkCard,
      error:            Color(0xFFEF4444),
      onError:          Colors.white,
    ),

    scaffoldBackgroundColor: kDarkBg,

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor:  kDarkBg,
      foregroundColor:  Colors.white,
      elevation:        0,
      centerTitle:      false,
      titleTextStyle: TextStyle(
        fontFamily:  _fontFamily,
        fontSize:    18,
        fontWeight:  FontWeight.w700,
        color:       Colors.white,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // Bottom nav
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      kDarkSurface,
      selectedItemColor:    kViolet,
      unselectedItemColor:  Colors.white38,
      type:                 BottomNavigationBarType.fixed,
      elevation:            0,
    ),

    // Navigation bar (M3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:            kDarkSurface,
      indicatorColor:             kViolet.withOpacity(0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kViolet);
        }
        return IconThemeData(color: Colors.white.withOpacity(0.4));
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily:  _fontFamily,
          fontSize:    11,
          fontWeight:  selected ? FontWeight.w600 : FontWeight.normal,
          color:       selected ? kViolet : Colors.white38,
        );
      }),
    ),

    // Cards
    cardTheme: CardThemeData(
      color:  kDarkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      margin: EdgeInsets.zero,
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor:    kDarkChip,
      selectedColor:      kViolet,
      disabledColor:      kDarkCard,
      labelStyle: const TextStyle(
        fontFamily:   _fontFamily,
        fontSize:     12,
        color:        Colors.white,
      ),
      side: BorderSide(color: Colors.white.withOpacity(0.06)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),

    // Input / text fields
    inputDecorationTheme: InputDecorationTheme(
      filled:           true,
      fillColor:        kDarkCard,
      contentPadding:   const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      hintStyle: TextStyle(
        color:      Colors.white.withOpacity(0.35),
        fontFamily: _fontFamily,
        fontSize:   14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:   BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kViolet, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      prefixIconColor: kViolet,
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:  kViolet,
        foregroundColor:  Colors.white,
        elevation:        0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily:  _fontFamily,
          fontSize:    15,
          fontWeight:  FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),

    // Outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kViolet,
        side: const BorderSide(color: kViolet, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize:   14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kViolet,
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize:   14,
        ),
      ),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kDarkSurface,
      contentTextStyle: const TextStyle(
        color:      Colors.white,
        fontFamily: _fontFamily,
        fontSize:   14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color:     Colors.white.withOpacity(0.07),
      thickness: 1,
      space:     1,
    ),

    // Icon
    iconTheme: IconThemeData(
      color: Colors.white.withOpacity(0.75),
      size:  22,
    ),

    // Text
    textTheme: _buildTextTheme(Colors.white),
  );

  // ── LIGHT THEME ───────────────────────────────────────────────────────────

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary:          kViolet,
      onPrimary:        Colors.white,
      secondary:        kAccent,
      onSecondary:      Colors.black,
      tertiary:         kHighlight,
      surface:          kLightSurface,
      onSurface:        Color(0xFF0F172A),
      surfaceContainerHighest: kLightCard,
      error:            Color(0xFFDC2626),
      onError:          Colors.white,
    ),

    scaffoldBackgroundColor: kLightBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: kLightSurface,
      foregroundColor: Color(0xFF0F172A),
      elevation:       0,
      centerTitle:     false,
      titleTextStyle: TextStyle(
        fontFamily:  _fontFamily,
        fontSize:    18,
        fontWeight:  FontWeight.w700,
        color:       Color(0xFF0F172A),
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Color(0xFF0F172A)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      kLightSurface,
      selectedItemColor:    kViolet,
      unselectedItemColor:  Color(0xFF94A3B8),
      type:                 BottomNavigationBarType.fixed,
      elevation:            0,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:            kLightSurface,
      indicatorColor:             kViolet.withOpacity(0.12),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kViolet);
        }
        return const IconThemeData(color: Color(0xFF94A3B8));
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily:  _fontFamily,
          fontSize:    11,
          fontWeight:  selected ? FontWeight.w600 : FontWeight.normal,
          color:       selected ? kViolet : const Color(0xFF94A3B8),
        );
      }),
    ),

    cardTheme: CardThemeData(
      color:     kLightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      margin: EdgeInsets.zero,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: kLightChip,
      selectedColor:   kViolet,
      labelStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize:   12,
        color:      Color(0xFF1E293B),
      ),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:         true,
      fillColor:      kLightCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      hintStyle: const TextStyle(
        color:      Color(0xFFADB5C7),
        fontFamily: _fontFamily,
        fontSize:   14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:   BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kViolet, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      prefixIconColor: kViolet,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kViolet,
        foregroundColor: Colors.white,
        elevation:       0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily:    _fontFamily,
          fontSize:      15,
          fontWeight:    FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kViolet,
        side: const BorderSide(color: kViolet, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize:   14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kViolet,
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize:   14,
        ),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: kLightSurface,
      contentTextStyle: const TextStyle(
        color:      Color(0xFF0F172A),
        fontFamily: _fontFamily,
        fontSize:   14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
    ),

    dividerTheme: const DividerThemeData(
      color:     Color(0xFFE2E8F0),
      thickness: 1,
      space:     1,
    ),

    iconTheme: const IconThemeData(
      color: Color(0xFF475569),
      size:  22,
    ),

    textTheme: _buildTextTheme(const Color(0xFF0F172A)),
  );

  // ── SHARED TEXT THEME ─────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color base) => TextTheme(
    displayLarge:  TextStyle(fontFamily: _fontFamily, fontSize: 36,
        fontWeight: FontWeight.w800, color: base, letterSpacing: -1.0),
    displayMedium: TextStyle(fontFamily: _fontFamily, fontSize: 30,
        fontWeight: FontWeight.w700, color: base, letterSpacing: -0.8),
    displaySmall:  TextStyle(fontFamily: _fontFamily, fontSize: 24,
        fontWeight: FontWeight.w700, color: base, letterSpacing: -0.5),
    headlineLarge: TextStyle(fontFamily: _fontFamily, fontSize: 22,
        fontWeight: FontWeight.w700, color: base),
    headlineMedium:TextStyle(fontFamily: _fontFamily, fontSize: 20,
        fontWeight: FontWeight.w600, color: base),
    headlineSmall: TextStyle(fontFamily: _fontFamily, fontSize: 18,
        fontWeight: FontWeight.w600, color: base),
    titleLarge:    TextStyle(fontFamily: _fontFamily, fontSize: 16,
        fontWeight: FontWeight.w600, color: base),
    titleMedium:   TextStyle(fontFamily: _fontFamily, fontSize: 14,
        fontWeight: FontWeight.w600, color: base),
    titleSmall:    TextStyle(fontFamily: _fontFamily, fontSize: 13,
        fontWeight: FontWeight.w500, color: base),
    bodyLarge:     TextStyle(fontFamily: _fontFamily, fontSize: 15,
        fontWeight: FontWeight.normal, color: base),
    bodyMedium:    TextStyle(fontFamily: _fontFamily, fontSize: 14,
        fontWeight: FontWeight.normal, color: base),
    bodySmall:     TextStyle(fontFamily: _fontFamily, fontSize: 12,
        fontWeight: FontWeight.normal,
        color: base.withOpacity(0.6)),
    labelLarge:    TextStyle(fontFamily: _fontFamily, fontSize: 13,
        fontWeight: FontWeight.w600, color: base, letterSpacing: 0.3),
    labelMedium:   TextStyle(fontFamily: _fontFamily, fontSize: 11,
        fontWeight: FontWeight.w500, color: base.withOpacity(0.7)),
    labelSmall:    TextStyle(fontFamily: _fontFamily, fontSize: 10,
        fontWeight: FontWeight.w500,
        color: base.withOpacity(0.5), letterSpacing: 0.5),
  );

  // ── GRADIENT HELPERS ──────────────────────────────────────────────────────

  /// The primary violet gradient used on buttons, banners, badges
  static LinearGradient get primaryGradient => _accentGradient;

  /// Golden accent gradient (e.g. sale badges, highlights)
  static const LinearGradient goldenGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFC843)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hot pink gradient (e.g. flash-sale, new-arrival labels)
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFE83A8A), Color(0xFFFF6BB5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}