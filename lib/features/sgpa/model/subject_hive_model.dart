import 'package:hive/hive.dart';

part 'subject_hive_model.g.dart';

@HiveType(typeId: 0)
class SubjectHiveModel {
  @HiveField(0)
  String subjectName;

  @HiveField(1)
  double credits;

  @HiveField(2)
  double gradePoint;

  SubjectHiveModel({
    required this.subjectName,
    required this.credits,
    required this.gradePoint,
  });
}