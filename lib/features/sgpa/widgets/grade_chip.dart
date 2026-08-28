import 'package:flutter/material.dart';

class GradeChip extends StatelessWidget {
  final String grade;
  final bool selected;
  final VoidCallback onTap;

  const GradeChip({
    super.key,
    required this.grade,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),

        margin: const EdgeInsets.only(
          right: 8,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: selected
              ? Colors.indigo
              : Theme.of(context)
              .cardTheme
              .color,

          borderRadius:
          BorderRadius.circular(
            16,
          ),

          border: Border.all(
            color: selected
                ? Colors.indigo
                : colorScheme.onSurface
                .withOpacity(0.08),
          ),

          boxShadow: selected
              ? [
            BoxShadow(
              blurRadius: 10,
              offset:
              const Offset(0, 4),
              color: Colors.indigo
                  .withOpacity(0.22),
            ),
          ]
              : [],
        ),

        child: Text(
          grade,

          style: TextStyle(
            fontWeight:
            FontWeight.bold,

            color: selected
                ? Colors.white
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}