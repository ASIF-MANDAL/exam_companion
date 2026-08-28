import 'package:flutter/material.dart';

class UpcomingExamTile extends StatelessWidget {
  final String subject;
  final String daysLeft;

  const UpcomingExamTile({
    super.key,
    required this.subject,
    required this.daysLeft,
  });

  Color getColor() {
    if (daysLeft == 'Today' || daysLeft == 'Tomorrow') {
      return Colors.red;
    }

    final days = int.tryParse(daysLeft.split(' ').first);

    if (days == null) {
      return Colors.indigo;
    }

    if (days <= 2) {
      return Colors.red;
    } else if (days <= 7) {
      return Colors.orange;
    } else {
      return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 5),
            color: colorScheme.onSurface.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
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
              subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 10),
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
              daysLeft,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}