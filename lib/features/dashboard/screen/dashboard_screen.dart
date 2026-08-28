import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exams/provider/exam_provider.dart';
import '../../timer/screen/timer_screen.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/greeting_section.dart';
import '../widgets/upcoming_exam_tile.dart';
import '../../../core/widgets/banner_ad_widget.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int) onNavigate;

  const DashboardScreen({
    super.key,
    required this.onNavigate,
  });

  int getDaysLeft(DateTime examDate) {
    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final examOnly = DateTime(
      examDate.year,
      examDate.month,
      examDate.day,
    );

    return examOnly.difference(todayOnly).inDays;
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final exams = ref.watch(examProvider);
    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final upcomingExams = exams.where((exam) {
      final examOnly = DateTime(
        exam.examDate.year,
        exam.examDate.month,
        exam.examDate.day,
      );

      return !examOnly.isBefore(todayOnly);
    }).take(3).toList();

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Exam Companion"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const GreetingSection(),

              const SizedBox(height: 28),

              GridView.count(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
                children: [
                  DashboardCard(
                    title: "SGPA",
                    icon: Icons.calculate,
                    onTap: () {
                      onNavigate(1);
                    },
                  ),
                  DashboardCard(
                    title: "Exams",
                    icon: Icons.calendar_month,
                    onTap: () {
                      onNavigate(2);
                    },
                  ),
                  DashboardCard(
                    title: "Notes",
                    icon: Icons.menu_book,
                    onTap: () {
                      onNavigate(3);
                    },
                  ),
                  DashboardCard(
                    title: "Study Timer",
                    icon: Icons.timer,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const TimerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 34),

              Row(
                children: [
                  Text(
                    "Upcoming Exams",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (upcomingExams.isNotEmpty)
                    Text(
                      '${upcomingExams.length} upcoming',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (upcomingExams.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color:
                    Theme.of(context).cardTheme.color,
                    borderRadius:
                    BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 44,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.45),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No upcoming exams added yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add exams to see reminders here',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...upcomingExams.map((exam) {
                  final daysLeft =
                  getDaysLeft(exam.examDate);

                  final text = daysLeft == 0
                      ? 'Today'
                      : daysLeft == 1
                      ? 'Tomorrow'
                      : '$daysLeft days';

                  return UpcomingExamTile(
                    subject: exam.subjectName,
                    daysLeft: text,
                  );
                }),
              const SizedBox(height: 20),

              const BannerAdWidget(),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}