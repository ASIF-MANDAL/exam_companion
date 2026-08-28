import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/exam_hive_model.dart';
import '../model/exam_model.dart';
import '../../../core/services/notification_service.dart';

final examProvider =
StateNotifierProvider<
    ExamNotifier,
    List<ExamModel>>(
      (ref) => ExamNotifier(),
);

class ExamNotifier
    extends StateNotifier<
        List<ExamModel>> {
  ExamNotifier() : super([]) {
    loadExams();
  }

  final Box box =
  Hive.box('exam_box');

  Future<void> loadExams() async {
    final saved =
    box.get('exams');

    if (saved == null) {
      state = [];
      return;
    }

    final exams =
    (saved as List)
        .map(
          (e) => ExamModel(
            id: e.id ??
                DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(),
            subjectName: e.subjectName,
            examDate: e.examDate,
            note: e.note,
          ),
    )
        .toList();

    exams.sort(
          (a, b) => a.examDate
          .compareTo(
        b.examDate,
      ),
    );

    state = exams;
  }

  Future<void> saveExams() async {
    final exams = state
        .map(
          (e) =>
              ExamHiveModel(
                id: e.id,
                subjectName: e.subjectName,
                examDate: e.examDate,
                note: e.note,
              ),
    )
        .toList();

    await box.put(
      'exams',
      exams,
    );
  }

  Future<void> addExam(
      ExamModel exam,
      ) async {
    final updated = [
      ...state,
      exam,
    ];

    updated.sort(
          (a, b) => a.examDate
          .compareTo(
        b.examDate,
      ),
    );

    state = updated;

    await saveExams();

    await NotificationService.scheduleExamReminder(
      examId: exam.id,
      subject: exam.subjectName,
      examDate: exam.examDate,
    );
  }

  Future<void> deleteExam(
      int index,
      ) async {
    final updated = [...state];

    await NotificationService.cancelExamReminder(
      updated[index].id,
    );

    updated.removeAt(index);

    state = updated;

    await saveExams();
  }
}