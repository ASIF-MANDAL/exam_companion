import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/subject_hive_model.dart';
import '../model/subject_model.dart';

final semesterProvider =
StateProvider<int>((ref) => 1);

final sgpaProvider =
StateNotifierProvider<SgpaNotifier,
    List<SubjectModel>>(
      (ref) => SgpaNotifier(),
);

class SgpaNotifier
    extends StateNotifier<List<SubjectModel>> {
  SgpaNotifier() : super([]);

  final Box box =
  Hive.box('semester_box');

  Future<void> loadSemester(
      int semester,
      ) async {
    final saved =
    box.get('sem_$semester');

    if (saved == null) {
      state = [];
      return;
    }

    final loaded =
    (saved as List)
        .map(
          (e) => SubjectModel(
        subjectName:
        e.subjectName,
        credits:
        (e.credits as num)
            .toDouble(),
        gradePoint:
        (e.gradePoint
        as num)
            .toDouble(),
      ),
    )
        .toList();

    state = loaded;
  }

  Future<void> saveSemester(
      int semester,
      ) async {
    final subjects = state
        .map(
          (e) =>
          SubjectHiveModel(
            subjectName:
            e.subjectName,
            credits:
            e.credits,
            gradePoint:
            e.gradePoint,
          ),
    )
        .toList();

    await box.put(
      'sem_$semester',
      subjects,
    );
  }

  Future<void> importSubjects(
      List<SubjectModel>
      subjects,
      ) async {
    state = subjects;
  }

  void clearSubjects() {
    state = [];
  }

  void addSubject() {
    state = [
      ...state,
      SubjectModel(
        subjectName: '',
        credits: 3.0,
        gradePoint: 8.0,
      ),
    ];
  }

  void removeSubject(
      int index,
      ) {
    final updated = [...state];

    updated.removeAt(index);

    state = updated;
  }

  void updateSubjectName(
      int index,
      String name,
      ) {
    state[index].subjectName =
        name;

    state = [...state];
  }

  void updateCredits(
      int index,
      double credits,
      ) {
    state[index].credits =
        credits;

    state = [...state];
  }

  void updateGrade(
      int index,
      double grade,
      ) {
    state[index].gradePoint =
        grade;

    state = [...state];
  }

  double calculateSgpa() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (final subject
    in state) {
      totalPoints +=
          subject.credits *
              subject
                  .gradePoint;

      totalCredits +=
          subject.credits;
    }

    if (totalCredits == 0) {
      return 0;
    }

    return totalPoints /
        totalCredits;
  }

  double totalCredits() {
    double credits = 0;

    for (final subject
    in state) {
      credits +=
          subject.credits;
    }

    return credits;
  }

  double totalCreditPoints() {
    double points = 0;

    for (final subject
    in state) {
      points +=
          subject.credits *
              subject
                  .gradePoint;
    }

    return points;
  }
}