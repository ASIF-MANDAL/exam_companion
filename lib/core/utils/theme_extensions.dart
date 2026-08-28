import 'package:flutter/material.dart';

extension ThemeColors on BuildContext {
  Color get bg => Theme.of(this).scaffoldBackgroundColor;

  Color get card =>
      Theme.of(this).cardTheme.color ??
          Theme.of(this).colorScheme.surface;

  Color get text =>
      Theme.of(this).colorScheme.onSurface;

  Color get mutedText =>
      Theme.of(this).colorScheme.onSurface.withOpacity(0.65);

  Color get primary =>
      Theme.of(this).colorScheme.primary;
}