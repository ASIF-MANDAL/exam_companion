import 'package:hive/hive.dart';

class CategoryLimitService {
  static const int freeCategoryLimit = 1;

  static Box get _box => Hive.box('settings_box');

  static int getCreatedCategoryCount() {
    return _box.get(
      'created_category_count',
      defaultValue: 0,
    );
  }

  static bool canCreateForFree() {
    return getCreatedCategoryCount() < freeCategoryLimit;
  }

  static Future<void> increaseCategoryCount() async {
    final count = getCreatedCategoryCount();

    await _box.put(
      'created_category_count',
      count + 1,
    );
  }
}