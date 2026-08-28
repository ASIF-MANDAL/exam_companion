import '../../sgpa/model/subject_model.dart';

class ParsedResult {
  final int semester;
  final double sgpa;
  final String result;
  final List<SubjectModel> subjects;

  ParsedResult({
    required this.semester,
    required this.sgpa,
    required this.result,
    required this.subjects,
  });
}

class MakautResultParser {
  static ParsedResult parse(String text) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final subjects = <SubjectModel>[];

    final rowRegex = RegExp(
      r'^([A-Z]+(?:-[A-Z]+)*\d{3}[A-Z]*)\s+(.+?)\s+([OEA-DFI])\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)$',
    );

    for (final line in lines) {
      final match = rowRegex.firstMatch(line);

      if (match != null) {
        final subjectName = match.group(2) ?? '';
        final gradePoint = double.tryParse(match.group(4) ?? '');
        final credits = double.tryParse(match.group(5) ?? '');

        if (gradePoint != null && credits != null) {
          subjects.add(
            SubjectModel(
              subjectName: subjectName,
              credits: credits,
              gradePoint: gradePoint,
            ),
          );
        }
      }
    }

    if (subjects.isEmpty) {
      _parseOldLineFormat(lines, subjects);
    }

    return ParsedResult(
      semester: _parseSemester(text),
      sgpa: _parseSgpa(text),
      result: _parseResult(text),
      subjects: subjects,
    );
  }

  static void _parseOldLineFormat(
      List<String> lines,
      List<SubjectModel> subjects,
      ) {
    final subjectCodeRegex = RegExp(
      r'^[A-Z]+(?:-[A-Z]+)*\d{3}[A-Z]*$',
    );

    for (int i = 0; i < lines.length - 5; i++) {
      if (subjectCodeRegex.hasMatch(lines[i])) {
        final subjectName = lines[i + 1];
        final gradePoint = double.tryParse(lines[i + 3]);
        final credits = double.tryParse(lines[i + 4]);

        if (gradePoint != null && credits != null) {
          subjects.add(
            SubjectModel(
              subjectName: subjectName,
              credits: credits,
              gradePoint: gradePoint,
            ),
          );
        }
      }
    }
  }

  static int _parseSemester(String text) {
    final match = RegExp(
      r'\((\d+)(?:st|nd|rd|th)\)\s*SEMESTER',
      caseSensitive: false,
    ).firstMatch(text);

    return int.tryParse(match?.group(1) ?? '1') ?? 1;
  }

  static double _parseSgpa(String text) {
    final match = RegExp(
      r'SGPA.*?SEMESTER\s*:\s*(\d+(?:\.\d+)?)',
      caseSensitive: false,
    ).firstMatch(text);

    return double.tryParse(match?.group(1) ?? '0') ?? 0;
  }

  static String _parseResult(String text) {
    final match = RegExp(
      r'RESULT.*?SEMESTER\s*:\s*([A-Z]+)',
      caseSensitive: false,
    ).firstMatch(text);

    return match?.group(1) ?? 'P';
  }
}