import 'package:flutter/material.dart';

class SemesterCgpaTile
    extends StatelessWidget {
  final int semester;
  final double sgpa;

  const SemesterCgpaTile({
    super.key,
    required this.semester,
    required this.sgpa,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      padding: const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color:
        Theme.of(context)
            .cardTheme
            .color,

        borderRadius:
        BorderRadius.circular(
          22,
        ),
      ),

      child: Row(
        children: [
          Text(
            'Semester $semester',

            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,

              color:
              Theme.of(context)
                  .colorScheme
                  .onSurface,
            ),
          ),

          const Spacer(),

          Text(
            sgpa
                .toStringAsFixed(
              2,
            ),

            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,

              color:
              Theme.of(context)
                  .colorScheme
                  .onSurface,
            ),
          ),
        ],
      ),
    );
  }
}