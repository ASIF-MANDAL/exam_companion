import 'package:hive/hive.dart';

class PdfImportLimitService {
  static const int freeDailyLimit = 3;

  static Box get _box => Hive.box('settings_box');

  static String _todayKey() {
    final now = DateTime.now();

    return '${now.year}-${now.month}-${now.day}';
  }

  static int getTodayImportCount() {
    final today = _todayKey();

    final savedDate = _box.get(
      'pdf_import_date',
      defaultValue: today,
    );

    if (savedDate != today) {
      _box.put('pdf_import_date', today);
      _box.put('pdf_import_count', 0);
      return 0;
    }

    return _box.get(
      'pdf_import_count',
      defaultValue: 0,
    );
  }

  static bool canImportForFree() {
    return getTodayImportCount() < freeDailyLimit;
  }

  static Future<void> increaseImportCount() async {
    final today = _todayKey();

    await _box.put(
      'pdf_import_date',
      today,
    );

    final count = getTodayImportCount();

    await _box.put(
      'pdf_import_count',
      count + 1,
    );
  }
}