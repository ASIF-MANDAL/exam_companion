import 'package:hive/hive.dart';

part 'note_hive_model.g.dart';

@HiveType(typeId: 2)
class NoteHiveModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String subject;

  @HiveField(3)
  int semester;

  @HiveField(4)
  String category;

  @HiveField(5)
  String privateFilePath;

  @HiveField(6)
  DateTime createdAt;

  NoteHiveModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.semester,
    required this.category,
    required this.privateFilePath,
    required this.createdAt,
  });
}