import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final cgpaProvider =
FutureProvider<
    Map<String, dynamic>>(
      (ref) async {
    final box =
    Hive.box(
      'semester_box',
    );

    double totalCredits =
    0;

    double totalPoints =
    0;

    List<
        Map<String, dynamic>>
    semesterData = [];

    for (int sem = 1;
    sem <= 8;
    sem++) {
      final saved =
      box.get(
        'sem_$sem',
      );

      if (saved == null ||
          (saved as List)
              .isEmpty) {
        continue;
      }

      double semCredits =
      0;

      double semPoints =
      0;

      for (final subject
      in saved) {
        final credits =
        (subject.credits
        as num)
            .toDouble();

        final gradePoint =
        (subject
            .gradePoint
        as num)
            .toDouble();

        semCredits +=
            credits;

        semPoints +=
            credits *
                gradePoint;
      }

      final sgpa =
      semCredits ==
          0
          ? 0
          : semPoints /
          semCredits;

      semesterData.add(
        {
          'semester':
          sem,
          'sgpa':
          sgpa,
        },
      );

      totalCredits +=
          semCredits;

      totalPoints +=
          semPoints;
    }

    final cgpa =
    totalCredits == 0
        ? 0
        : totalPoints /
        totalCredits;

    return {
      'cgpa': cgpa,
      'semesters':
      semesterData,
    };
  },
);