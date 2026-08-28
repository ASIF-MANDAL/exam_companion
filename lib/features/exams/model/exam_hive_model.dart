import 'package:hive/hive.dart';

part 'exam_hive_model.g.dart';

@HiveType(typeId: 1)
class ExamHiveModel {
  @HiveField(0)
  String subjectName;

  @HiveField(1)
  DateTime examDate;

  @HiveField(2)
  String note;

  @HiveField(3)
  String? id;

  ExamHiveModel({
    required this.subjectName,
    required this.examDate,
    required this.note,
    this.id,
  });
}