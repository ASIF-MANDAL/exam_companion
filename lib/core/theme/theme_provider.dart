import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    loadTheme();
  }

  final Box box = Hive.box('settings_box');

  void loadTheme() {
    final savedTheme = box.get(
      'theme_mode',
      defaultValue: 'system',
    );

    if (savedTheme == 'light') {
      state = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;

    String value = 'system';

    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    }

    await box.put('theme_mode', value);
  }
}