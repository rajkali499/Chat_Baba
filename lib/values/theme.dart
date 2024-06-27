import "package:flutter/material.dart";

MaterialScheme lightScheme() {
  return const MaterialScheme(
    brightness: Brightness.light,
    primary: Color(4287580750),
    surfaceTint: Color(4287580750),
    onPrimary: Color(4294967295),
    primaryContainer: Color(4294957786),
    onPrimaryContainer: Color(4282058767),
    secondary: Color(4285945431),
    onSecondary: Color(4294967295),
    secondaryContainer: Color(4294957786),
    onSecondaryContainer: Color(4281079062),
    tertiary: Color(4285946159),
    onTertiary: Color(4294967295),
    tertiaryContainer: Color(4294958514),
    onTertiaryContainer: Color(4280883200),
    error: Color(4290386458),
    onError: Color(4294967295),
    errorContainer: Color(4294957782),
    onErrorContainer: Color(4282449922),
    background: Color(4294965495),
    onBackground: Color(4280424730),
    surface: Color(4294965495),
    onSurface: Color(4280424730),
    surfaceVariant: Color(4294237661),
    onSurfaceVariant: Color(4283581251),
    outline: Color(4286935923),
    outlineVariant: Color(4292329921),
    shadow: Color(4278190080),
    scrim: Color(4278190080),
    inverseSurface: Color(4281871918),
    inverseOnSurface: Color(4294962668),
    inversePrimary: Color(4294947765),
    primaryFixed: Color(4294957786),
    onPrimaryFixed: Color(4282058767),
    primaryFixedDim: Color(4294947765),
    onPrimaryFixedVariant: Color(4285674296),
    secondaryFixed: Color(4294957786),
    onSecondaryFixed: Color(4281079062),
    secondaryFixedDim: Color(4293311933),
    onSecondaryFixedVariant: Color(4284301120),
    tertiaryFixed: Color(4294958514),
    onTertiaryFixed: Color(4280883200),
    tertiaryFixedDim: Color(4293312653),
    onTertiaryFixedVariant: Color(4284236314),
    surfaceDim: Color(4293383894),
    surfaceBright: Color(4294965495),
    surfaceContainerLowest: Color(4294967295),
    surfaceContainerLow: Color(4294963440),
    surfaceContainer: Color(4294765289),
    surfaceContainerHigh: Color(4294370532),
    surfaceContainerHighest: Color(4293975774),
  );
}
ThemeData light() {
  return theme(lightScheme().toColorScheme());
}

MaterialScheme darkScheme() {
  return const MaterialScheme(
    brightness: Brightness.dark,
    primary: Color(4294947765),
    surfaceTint: Color(4294947765),
    onPrimary: Color(4283833635),
    primaryContainer: Color(4285674296),
    onPrimaryContainer: Color(4294957786),
    secondary: Color(4293311933),
    onSecondary: Color(4282657066),
    secondaryContainer: Color(4284301120),
    onSecondaryContainer: Color(4294957786),
    tertiary: Color(4293312653),
    onTertiary: Color(4282592262),
    tertiaryContainer: Color(4284236314),
    onTertiaryContainer: Color(4294958514),
    error: Color(4294948011),
    onError: Color(4285071365),
    errorContainer: Color(4287823882),
    onErrorContainer: Color(4294957782),
    background: Color(4279898385),
    onBackground: Color(4293975774),
    surface: Color(4279898385),
    onSurface: Color(4293975774),
    surfaceVariant: Color(4283581251),
    onSurfaceVariant: Color(4292329921),
    outline: Color(4288646284),
    outlineVariant: Color(4283581251),
    shadow: Color(4278190080),
    scrim: Color(4278190080),
    inverseSurface: Color(4293975774),
    inverseOnSurface: Color(4281871918),
    inversePrimary: Color(4287580750),
    primaryFixed: Color(4294957786),
    onPrimaryFixed: Color(4282058767),
    primaryFixedDim: Color(4294947765),
    onPrimaryFixedVariant: Color(4285674296),
    secondaryFixed: Color(4294957786),
    onSecondaryFixed: Color(4281079062),
    secondaryFixedDim: Color(4293311933),
    onSecondaryFixedVariant: Color(4284301120),
    tertiaryFixed: Color(4294958514),
    onTertiaryFixed: Color(4280883200),
    tertiaryFixedDim: Color(4293312653),
    onTertiaryFixedVariant: Color(4284236314),
    surfaceDim: Color(4279898385),
    surfaceBright: Color(4282464055),
    surfaceContainerLowest: Color(4279503884),
    surfaceContainerLow: Color(4280424730),
    surfaceContainer: Color(4280753437),
    surfaceContainerHigh: Color(4281477160),
    surfaceContainerHighest: Color(4282200626),
  );
}
ThemeData dark() {
  return theme(darkScheme().toColorScheme());
}

ThemeData theme(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: const TextTheme(),
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: colorScheme.surface,
    );

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}
