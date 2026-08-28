import 'package:flutter/material.dart';

import '../model/exam_model.dart';

class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onDelete;

  const ExamCard({
    super.key,
    required this.exam,
    required this.onDelete,
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

  String getCountdownText(int daysLeft) {
    if (daysLeft == 0) return 'Today';
    if (daysLeft == 1) return 'Tomorrow';
    if (daysLeft < 0) return 'Completed';
    return '$daysLeft days left';
  }

  Color getUrgencyColor(int daysLeft) {
    if (daysLeft < 0) return Colors.grey;
    if (daysLeft <= 2) return Colors.red;
    if (daysLeft <= 7) return Colors.orange;
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = getDaysLeft(exam.examDate);
    final color = getUrgencyColor(daysLeft);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: colorScheme.onSurface.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  Icons.calendar_month,
                  color: color,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  exam.subjectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: colorScheme.onSurface
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              getCountdownText(daysLeft),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.event,
                size: 18,
                color: colorScheme.onSurface
                    .withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                '${exam.examDate.day}/${exam.examDate.month}/${exam.examDate.year}',
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (exam.note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                exam.note,
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.65),
                ),
              ),
            ),
        ],
      ),
    );
  }
}