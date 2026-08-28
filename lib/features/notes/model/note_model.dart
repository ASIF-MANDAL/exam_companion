class NoteModel {
  final String id;
  final String title;
  final String subject;
  final int semester;
  final String category;
  final String privateFilePath;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.semester,
    required this.category,
    required this.privateFilePath,
    required this.createdAt,
  });
}