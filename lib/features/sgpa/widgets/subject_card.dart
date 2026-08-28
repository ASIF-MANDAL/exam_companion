import 'package:flutter/material.dart';

import '../model/subject_model.dart';
import 'grade_chip.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final int index;
  final Function(double) onCreditChange;
  final Function(double) onGradeChange;
  final Function(String) onNameChange;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.index,
    required this.onCreditChange,
    required this.onGradeChange,
    required this.onNameChange,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final gradeMap = {
      'O': 10.0,
      'E': 9.0,
      'A': 8.0,
      'B': 7.0,
      'C': 6.0,
      'D': 5.0,
      'F': 2.0,
      'I': 2.0,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                colorScheme.primary.withOpacity(0.12),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Subject ${index + 1}',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextFormField(
            initialValue: subject.subjectName,
            decoration: const InputDecoration(
              hintText: "Subject Name",
              border: OutlineInputBorder(),
            ),
            onChanged: onNameChange,
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<double>(
            value: subject.credits,
            decoration: const InputDecoration(
              labelText: "Credits",
              border: OutlineInputBorder(),
            ),
            items: const <double>[
              1.0,
              1.5,
              2.0,
              2.5,
              3.0,
              4.0,
              5.0,
            ].map((double e) {
              return DropdownMenuItem<double>(
                value: e,
                child: Text(e.toString()),
              );
            }).toList(),
            onChanged: (double? value) {
              if (value != null) {
                onCreditChange(value);
              }
            },
          ),

          const SizedBox(height: 18),

          Text(
            'Grade',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: gradeMap.entries.map((e) {
                return GradeChip(
                  grade: e.key,
                  selected: subject.gradePoint == e.value,
                  onTap: () {
                    onGradeChange(e.value);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}