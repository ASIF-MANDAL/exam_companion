import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/exam_provider.dart';
import '../widgets/add_exam_bottom_sheet.dart';
import '../widgets/exam_card.dart';

class ExamsScreen extends ConsumerWidget {
  const ExamsScreen({super.key});

  void showAddExamSheet(
      BuildContext context,
      WidgetRef ref,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return AddExamBottomSheet(
          onAdd: (exam) {
            ref
                .read(examProvider.notifier)
                .addExam(exam);
          },
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final exams = ref.watch(examProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Exam Tracker'),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          showAddExamSheet(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Exam'),
      ),
      body: SafeArea(
        child: exams.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 72,
                  color: colorScheme.onSurface
                      .withOpacity(0.35),
                ),
                const SizedBox(height: 16),
                Text(
                  'No exams added yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + Add Exam to create your first countdown.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface
                        .withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            final exam = exams[index];

            return ExamCard(
              exam: exam,
              onDelete: () {
                ref
                    .read(examProvider.notifier)
                    .deleteExam(index);
              },
            );
          },
        ),
      ),
    );
  }
}