import 'package:flutter/material.dart';

/// A calm, low-chrome look: one muted accent, generous whitespace, soft
/// rounded shapes, and almost no elevation. Shared by light and dark.

const _seed = Color(0xFF5E8B7E); // muted sage — calm, not clinical

/// Standard page padding. Screens use this so spacing stays consistent.
const double kGutter = 16;

/// Comfortable reading width; list content is centred within this on wide
/// windows instead of stretching edge to edge.
const double kContentMaxWidth = 640;

ThemeData buildLightTheme() =>
    _base(ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light));

ThemeData buildDarkTheme() =>
    _base(ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark));

ThemeData _base(ColorScheme scheme) {
  final radius12 = BorderRadius.circular(12);
  final radius16 = BorderRadius.circular(16);

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    visualDensity: VisualDensity.standard,
    splashFactory: InkSparkle.splashFactory,

    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0.5,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: scheme.secondaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),

    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.secondaryContainer,
      labelType: NavigationRailLabelType.all,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius16),
      margin: EdgeInsets.zero,
    ),

    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: radius12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.5),
      space: 1,
      thickness: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      border: OutlineInputBorder(
        borderRadius: radius12,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius12,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius12,
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius12),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 1,
      focusElevation: 1,
      hoverElevation: 2,
      highlightElevation: 1,
      shape: RoundedRectangleBorder(borderRadius: radius16),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: radius12),
        ),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: radius12),
    ),

    tabBarTheme: const TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
    ),
  );
}
