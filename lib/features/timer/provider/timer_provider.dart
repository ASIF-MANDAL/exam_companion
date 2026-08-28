import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'study_stats_provider.dart';

final timerProvider =
StateNotifierProvider<TimerNotifier, TimerState>(
      (ref) => TimerNotifier(ref),
);

class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final bool isBreak;
  final int completedSessions;
  final int focusMinutes;
  final int breakMinutes;

  TimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.isBreak,
    required this.completedSessions,
    required this.focusMinutes,
    required this.breakMinutes,
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isBreak,
    int? completedSessions,
    int? focusMinutes,
    int? breakMinutes,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
      completedSessions: completedSessions ?? this.completedSessions,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  final Ref ref;

  TimerNotifier(this.ref)
      : super(
    TimerState(
      remainingSeconds: 25 * 60,
      isRunning: false,
      isBreak: false,
      completedSessions: 0,
      focusMinutes: 25,
      breakMinutes: 5,
    ),
  ) {
    loadSettings();
  }

  Timer? _timer;
  final Box settingsBox = Hive.box('settings_box');

  void loadSettings() {
    final focus = settingsBox.get(
      'focus_minutes',
      defaultValue: 25,
    );

    final breakTime = settingsBox.get(
      'break_minutes',
      defaultValue: 5,
    );

    state = state.copyWith(
      focusMinutes: focus,
      breakMinutes: breakTime,
      remainingSeconds: focus * 60,
    );
  }

  Future<void> updateSettings({
    required int focusMinutes,
    required int breakMinutes,
  }) async {
    await settingsBox.put('focus_minutes', focusMinutes);
    await settingsBox.put('break_minutes', breakMinutes);

    _timer?.cancel();

    state = state.copyWith(
      focusMinutes: focusMinutes,
      breakMinutes: breakMinutes,
      remainingSeconds: focusMinutes * 60,
      isRunning: false,
      isBreak: false,
    );
  }

  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(
            remainingSeconds: state.remainingSeconds - 1,
          );
        } else {
          _switchMode();
        }
      },
    );
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();

    state = state.copyWith(
      remainingSeconds: state.focusMinutes * 60,
      isRunning: false,
      isBreak: false,
    );
  }

  Future<void> _switchMode() async {
    _timer?.cancel();

    if (state.isBreak) {
      state = state.copyWith(
        remainingSeconds: state.focusMinutes * 60,
        isRunning: false,
        isBreak: false,
      );
    } else {
      state = state.copyWith(
        remainingSeconds: state.breakMinutes * 60,
        isRunning: false,
        isBreak: true,
        completedSessions: state.completedSessions + 1,
      );

      await ref
          .read(studyStatsProvider.notifier)
          .addCompletedSession(
        state.focusMinutes,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}