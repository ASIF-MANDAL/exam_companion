import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/study_stats_model.dart';

final studyStatsProvider =
StateNotifierProvider<
    StudyStatsNotifier,
    StudyStatsModel>(
      (ref) => StudyStatsNotifier(),
);

class StudyStatsNotifier
    extends StateNotifier<StudyStatsModel> {
  StudyStatsNotifier()
      : super(
    StudyStatsModel(
      totalFocusMinutes: 0,
      completedSessions: 0,
      currentStreak: 0,
      bestStreak: 0,
      todayFocusMinutes: 0,
      weeklyFocusMinutes: 0,
      averageDailyMinutes: 0,
      lastStudyDate: null,
    ),
  ) {
    loadStats();
  }

  final Box box =
  Hive.box('settings_box');

  void loadStats() {
    int weeklyTotal = 0;

    for (int i = 1; i <= 7; i++) {
      weeklyTotal +=
      (box.get(
        'study_day_$i',
      ) ?? 0) as int;
    }

    final totalMinutes =
    (box.get(
      'total_focus_minutes',
    ) ?? 0) as int;

    final sessions =
    (box.get(
      'completed_sessions',
    ) ?? 0) as int;

    final double average =
    sessions == 0
        ? 0.0
        : totalMinutes / sessions;

    final now =
    DateTime.now();

    final todayKey =
        'study_day_${now.weekday}';

    state = StudyStatsModel(
      totalFocusMinutes:
      totalMinutes,

      completedSessions:
      sessions,

      currentStreak:
      (box.get(
        'current_streak',
      ) ?? 0) as int,

      bestStreak:
      (box.get(
        'best_streak',
      ) ?? 0) as int,

      todayFocusMinutes:
      (box.get(
        todayKey,
      ) ?? 0) as int,

      weeklyFocusMinutes:
      weeklyTotal,

      averageDailyMinutes:
      average,

      lastStudyDate:
      box.get('last_study_date'),
    );
  }

  Future<void> addCompletedSession(
      int focusMinutes,
      ) async {
    final now =
    DateTime.now();

    final today =
        '${now.year}-${now.month}-${now.day}';

    int streak =
        state.currentStreak;

    if (state.lastStudyDate != today) {
      streak += 1;
    }

    int bestStreak =
        state.bestStreak;

    if (streak > bestStreak) {
      bestStreak = streak;
    }

    final weekdayKey =
        'study_day_${now.weekday}';

    final currentMinutes =
    box.get(
      weekdayKey,
      defaultValue: 0,
    );

    await box.put(
      weekdayKey,
      currentMinutes + focusMinutes,
    );

    await box.put(
      'total_focus_minutes',
      state.totalFocusMinutes +
          focusMinutes,
    );

    await box.put(
      'completed_sessions',
      state.completedSessions + 1,
    );

    await box.put(
      'current_streak',
      streak,
    );

    await box.put(
      'best_streak',
      bestStreak,
    );

    await box.put(
      'last_study_date',
      today,
    );

    loadStats();
  }
}