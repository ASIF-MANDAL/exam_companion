import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/timer_provider.dart';
import 'study_analytics_screen.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  String formatTime(int seconds) {
    final minutes =
    (seconds ~/ 60).toString().padLeft(2, '0');

    final remainingSeconds =
    (seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$remainingSeconds';
  }

  void showTimerSettings(
      BuildContext context,
      WidgetRef ref,
      TimerState timerState,
      ) {
    final focusController =
    TextEditingController(
      text: timerState.focusMinutes.toString(),
    );

    final breakController =
    TextEditingController(
      text: timerState.breakMinutes.toString(),
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Timer Settings',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                focusController,

                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(
                  labelText:
                  'Focus minutes',

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller:
                breakController,

                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(
                  labelText:
                  'Break minutes',

                  border:
                  OutlineInputBorder(),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child:
              const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final focus =
                int.tryParse(
                  focusController.text
                      .trim(),
                );

                final breakTime =
                int.tryParse(
                  breakController.text
                      .trim(),
                );

                if (focus == null ||
                    breakTime ==
                        null ||
                    focus <= 0 ||
                    breakTime <= 0) {
                  return;
                }

                await ref
                    .read(
                  timerProvider
                      .notifier,
                )
                    .updateSettings(
                  focusMinutes:
                  focus,
                  breakMinutes:
                  breakTime,
                );

                if (context
                    .mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },

              child:
              const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final timerState =
    ref.watch(timerProvider);

    final notifier =
    ref.read(
      timerProvider.notifier,
    );

    final totalSeconds =
    timerState.isBreak
        ? timerState.breakMinutes *
        60
        : timerState.focusMinutes *
        60;

    final progress =
        1 -
            (timerState
                .remainingSeconds /
                totalSeconds);

    final colorScheme =
        Theme.of(context)
            .colorScheme;

    final accentColor =
    timerState.isBreak
        ? Colors.green
        : Colors.indigo;

    return Scaffold(
      backgroundColor:
      Theme.of(context)
          .scaffoldBackgroundColor,

      appBar: AppBar(
        title:
        const Text('Study Timer'),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                  const StudyAnalyticsScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.bar_chart,
            ),
          ),

          IconButton(
            onPressed: () {
              showTimerSettings(
                context,
                ref,
                timerState,
              );
            },

            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.all(
            24,
          ),

          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              Text(
                timerState.isBreak
                    ? 'Break Time'
                    : 'Focus Session',

                style: TextStyle(
                  fontSize: 30,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  colorScheme
                      .onSurface,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                timerState.isBreak
                    ? 'Relax for a few minutes'
                    : 'Stay focused and avoid distractions',

                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: colorScheme
                      .onSurface
                      .withOpacity(
                    0.65,
                  ),

                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 42,
              ),

              Container(
                padding:
                const EdgeInsets.all(
                  24,
                ),

                decoration:
                BoxDecoration(
                  shape:
                  BoxShape.circle,

                  color:
                  Theme.of(
                    context,
                  ).cardTheme.color,

                  boxShadow: [
                    BoxShadow(
                      blurRadius:
                      18,

                      offset:
                      const Offset(
                        0,
                        8,
                      ),

                      color:
                      accentColor
                          .withOpacity(
                        0.18,
                      ),
                    ),
                  ],
                ),

                child: SizedBox(
                  width: 220,
                  height: 220,

                  child: Stack(
                    alignment:
                    Alignment.center,

                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,

                        child:
                        CircularProgressIndicator(
                          value:
                          progress,

                          strokeWidth:
                          12,

                          backgroundColor:
                          colorScheme
                              .onSurface
                              .withOpacity(
                            0.12,
                          ),

                          color:
                          accentColor,
                        ),
                      ),

                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [
                          Text(
                            formatTime(
                              timerState
                                  .remainingSeconds,
                            ),

                            style:
                            TextStyle(
                              fontSize:
                              44,

                              fontWeight:
                              FontWeight
                                  .bold,

                              color:
                              colorScheme
                                  .onSurface,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            timerState
                                .isBreak
                                ? 'Break'
                                : 'Focus',

                            style:
                            TextStyle(
                              color:
                              colorScheme
                                  .onSurface
                                  .withOpacity(
                                0.6,
                              ),

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 36,
              ),

              Container(
                width: double.infinity,

                padding:
                const EdgeInsets.all(
                  22,
                ),

                decoration:
                BoxDecoration(
                  color:
                  Theme.of(
                    context,
                  ).cardTheme.color,

                  borderRadius:
                  BorderRadius.circular(
                    26,
                  ),

                  boxShadow: [
                    BoxShadow(
                      blurRadius:
                      12,

                      offset:
                      const Offset(
                        0,
                        5,
                      ),

                      color:
                      colorScheme
                          .onSurface
                          .withOpacity(
                        0.05,
                      ),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,

                      backgroundColor:
                      accentColor
                          .withOpacity(
                        0.12,
                      ),

                      child: Icon(
                        Icons
                            .analytics,

                        color:
                        accentColor,
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [
                          Text(
                            'Completed Sessions',

                            style:
                            TextStyle(
                              color:
                              colorScheme
                                  .onSurface
                                  .withOpacity(
                                0.65,
                              ),

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            '${timerState.completedSessions}',

                            style:
                            TextStyle(
                              fontSize:
                              28,

                              fontWeight:
                              FontWeight
                                  .bold,

                              color:
                              colorScheme
                                  .onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 26,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                    ElevatedButton.icon(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        accentColor,

                        foregroundColor:
                        Colors.white,

                        padding:
                        const EdgeInsets.symmetric(
                          vertical:
                          16,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed:
                      timerState
                          .isRunning
                          ? notifier.pause
                          : notifier.start,

                      icon: Icon(
                        timerState
                            .isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),

                      label: Text(
                        timerState
                            .isRunning
                            ? 'Pause'
                            : 'Start',
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child:
                    OutlinedButton.icon(
                      style:
                      OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(
                          vertical:
                          16,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed:
                      notifier.reset,

                      icon: const Icon(
                        Icons.restart_alt,
                      ),

                      label:
                      const Text(
                        'Reset',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}