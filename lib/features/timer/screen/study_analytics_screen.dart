import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/study_stats_provider.dart';

class StudyAnalyticsScreen extends ConsumerWidget {
  const StudyAnalyticsScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final stats = ref.watch(
      studyStatsProvider,
    );

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Study Analytics',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    Colors.indigo.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Colors.indigo.withOpacity(0.25),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Focus Time',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${stats.totalFocusMinutes} min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Keep building your study habit',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _card(
              context: context,
              title: 'Completed Sessions',
              value: '${stats.completedSessions}',
              icon: Icons.check_circle,
              color: Colors.green,
            ),

            _card(
              context: context,
              title: 'Current Streak',
              value: '${stats.currentStreak} days',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),

            _card(
              context: context,
              title: 'Today',
              value: '${stats.todayFocusMinutes} min',
              icon: Icons.today,
              color: Colors.blue,
            ),

            _card(
              context: context,
              title: 'This Week',
              value: '${stats.weeklyFocusMinutes} min',
              icon: Icons.calendar_month,
              color: Colors.purple,
            ),

            _card(
              context: context,
              title: 'Best Streak',
              value: '${stats.bestStreak} days',
              icon: Icons.local_fire_department,
              color: Colors.red,
            ),

            _card(
              context: context,
              title: 'Average Session',
              value:
              '${stats.averageDailyMinutes.toStringAsFixed(1)} min',
              icon: Icons.bar_chart,
              color: Colors.teal,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
        Theme.of(context)
            .cardTheme
            .color,
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: colorScheme.onSurface
                .withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            color.withOpacity(0.12),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface
                        .withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}