class StudyStatsModel {
  final int totalFocusMinutes;
  final int completedSessions;
  final int currentStreak;
  final int bestStreak;
  final int todayFocusMinutes;
  final int weeklyFocusMinutes;
  final double averageDailyMinutes;
  final String? lastStudyDate;

  StudyStatsModel({
    required this.totalFocusMinutes,
    required this.completedSessions,
    required this.currentStreak,
    required this.bestStreak,
    required this.todayFocusMinutes,
    required this.weeklyFocusMinutes,
    required this.averageDailyMinutes,
    required this.lastStudyDate,
  });

  StudyStatsModel copyWith({
    int? totalFocusMinutes,
    int? completedSessions,
    int? currentStreak,
    int? bestStreak,
    int? todayFocusMinutes,
    int? weeklyFocusMinutes,
    double? averageDailyMinutes,
    String? lastStudyDate,
  }) {
    return StudyStatsModel(
      totalFocusMinutes:
      totalFocusMinutes ??
          this.totalFocusMinutes,
      completedSessions:
      completedSessions ??
          this.completedSessions,
      currentStreak:
      currentStreak ??
          this.currentStreak,
      bestStreak:
      bestStreak ??
          this.bestStreak,
      todayFocusMinutes:
      todayFocusMinutes ??
          this.todayFocusMinutes,
      weeklyFocusMinutes:
      weeklyFocusMinutes ??
          this.weeklyFocusMinutes,
      averageDailyMinutes:
      averageDailyMinutes ??
          this.averageDailyMinutes,
      lastStudyDate:
      lastStudyDate ??
          this.lastStudyDate,
    );
  }
}