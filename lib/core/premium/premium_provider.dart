import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final premiumProvider =
StateNotifierProvider<PremiumNotifier, bool>(
      (ref) => PremiumNotifier(),
);

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    loadPremium();
  }

  final Box box = Hive.box('settings_box');

  void loadPremium() {
    state = box.get(
      'is_premium',
      defaultValue: false,
    );
  }

  Future<void> setPremium(bool value) async {
    state = value;

    await box.put(
      'is_premium',
      value,
    );
  }
}