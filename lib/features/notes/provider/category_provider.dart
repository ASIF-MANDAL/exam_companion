import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final categoryProvider =
StateNotifierProvider<CategoryNotifier, List<String>>(
      (ref) => CategoryNotifier(),
);

class CategoryNotifier extends StateNotifier<List<String>> {
  CategoryNotifier() : super([]) {
    loadCategories();
  }

  final Box box = Hive.box('notes_box');

  final defaultCategories = const [
    'Notes',
    'PYQ',
    'Assignment',
    'Important',
  ];

  Future<void> loadCategories() async {
    final saved = box.get('categories');

    if (saved == null) {
      state = defaultCategories;
      await saveCategories();
      return;
    }

    state = List<String>.from(saved);
  }

  Future<void> saveCategories() async {
    await box.put('categories', state);
  }

  Future<void> addCategory(String category) async {
    final clean = category.trim();

    if (clean.isEmpty) {
      return;
    }

    final exists = state.any(
          (e) => e.toLowerCase() == clean.toLowerCase(),
    );

    if (exists) {
      return;
    }

    state = [
      ...state,
      clean,
    ];

    await saveCategories();
  }

  Future<void> renameCategory({
    required String oldName,
    required String newName,
  }) async {
    final clean = newName.trim();

    if (clean.isEmpty) {
      return;
    }

    state = state.map((category) {
      if (category == oldName) {
        return clean;
      }

      return category;
    }).toList();

    await saveCategories();
  }

  Future<void> deleteCategory(String category) async {
    state = state
        .where(
          (e) => e != category,
    )
        .toList();

    await saveCategories();
  }
}