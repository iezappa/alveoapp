import 'package:flutter/material.dart';

/// A calm, warm, low-chrome look: paper-like surfaces, one muted accent, a
/// serif for headings, soft rounded shapes, and almost no elevation.

/// Serif family (see pubspec `fonts:`), used for headings and titles.
const String kSerif = 'Lora';

/// The pickable accent colours. Every seed is desaturated so the palette stays
/// calm regardless of hue.
enum AppAccent { green, blue, pink, violet, orange, red }

extension AppAccentSeed on AppAccent {
  Color get seed => switch (this) {
    AppAccent.green => const Color(0xFF5E8B7E),
    AppAccent.blue => const Color(0xFF5C7C9E),
    AppAccent.pink => const Color(0xFFB56C86),
    AppAccent.violet => const Color(0xFF7C6BA8),
    AppAccent.orange => const Color(0xFFC1804E),
    AppAccent.red => const Color(0xFFB25E54),
  };
}

/// Standard page padding. Screens use this so spacing stays consistent.
const double kGutter = 16;

/// Comfortable reading width; list content is centred within this on wide
/// windows instead of stretching edge to edge.
const double kContentMaxWidth = 640;

ThemeData buildLightTheme([AppAccent accent = AppAccent.green]) => _base(
  _warm(
    ColorScheme.fromSeed(seedColor: accent.seed, brightness: Brightness.light),
    light: true,
  ),
  light: true,
);

ThemeData buildDarkTheme([AppAccent accent = AppAccent.green]) => _base(
  _warm(
    ColorScheme.fromSeed(seedColor: accent.seed, brightness: Brightness.dark),
    light: false,
  ),
  light: false,
);

/// Nudges the neutral surfaces of [scheme] toward a soft, paper-like cream
/// (or a warm charcoal in the dark), leaving the accent roles untouched.
ColorScheme _warm(ColorScheme scheme, {required bool light}) {
  if (light) {
    return scheme.copyWith(
      surface: const Color(0xFFFBF7F1),
      surfaceContainerLowest: const Color(0xFFFFFDFA),
      surfaceContainerLow: const Color(0xFFF5EFE4),
      surfaceContainer: const Color(0xFFEFE8DA),
      surfaceContainerHigh: const Color(0xFFE9E0CE),
      surfaceContainerHighest: const Color(0xFFE3D8C2),
      outlineVariant: const Color(0xFFDDD2BF),
    );
  }
  return scheme.copyWith(
    surface: const Color(0xFF15130F),
    surfaceContainerLowest: const Color(0xFF100E0B),
    surfaceContainerLow: const Color(0xFF1F1B15),
    surfaceContainer: const Color(0xFF262119),
    surfaceContainerHigh: const Color(0xFF2F2920),
    surfaceContainerHighest: const Color(0xFF3A3327),
  );
}

ThemeData _base(ColorScheme scheme, {required bool light}) {
  final radius12 = BorderRadius.circular(12);
  final radius16 = BorderRadius.circular(16);
  final radius22 = BorderRadius.circular(22);

  TextStyle serif(double size, {FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontFamily: kSerif,
        fontSize: size,
        fontWeight: weight,
        height: 1.2,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      );

  final theme = ThemeData(
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
      titleTextStyle: serif(21),
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
      shadowColor: Colors.black.withValues(alpha: light ? 0.04 : 0.2),
      shape: RoundedRectangleBorder(borderRadius: radius22),
      margin: EdgeInsets.zero,
    ),

    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: radius16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outlineVariant),
      backgroundColor: scheme.surfaceContainerLow,
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.6),
      space: 1,
      thickness: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHigh.withValues(alpha: 0.45),
      border: OutlineInputBorder(
        borderRadius: radius16,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius16,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius16,
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius16),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius16),
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
      shape: RoundedRectangleBorder(borderRadius: radius22),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: radius16),
        ),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: radius16),
    ),

    tabBarTheme: const TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
    ),
  );

  return theme.copyWith(
    textTheme: theme.textTheme.copyWith(
      displayLarge: serif(44, weight: FontWeight.w600),
      displayMedium: serif(36, weight: FontWeight.w600),
      displaySmall: serif(30, weight: FontWeight.w600),
      headlineLarge: serif(28),
      headlineMedium: serif(24),
      headlineSmall: serif(21),
      titleLarge: serif(19),
    ),
  );
}
