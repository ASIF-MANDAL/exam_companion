import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/note_hive_model.dart';
import '../model/note_model.dart';

final notesProvider =
StateNotifierProvider<NotesNotifier, List<NoteModel>>(
      (ref) => NotesNotifier(),
);

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier() : super([]) {
    loadNotes();
  }

  Future<void> renameNote({
    required String id,
    required String newTitle,
  }) async {
    state = state.map((note) {
      if (note.id == id) {
        return NoteModel(
          id: note.id,
          title: newTitle,
          subject: note.subject,
          semester: note.semester,
          category: note.category,
          privateFilePath: note.privateFilePath,
          createdAt: note.createdAt,
        );
      }

      return note;
    }).toList();

    await saveNotes();
  }

  Future<void> moveNoteCategory({
    required String id,
    required String newCategory,
  }) async {
    state = state.map((note) {
      if (note.id == id) {
        return NoteModel(
          id: note.id,
          title: note.title,
          subject: note.subject,
          semester: note.semester,
          category: newCategory,
          privateFilePath: note.privateFilePath,
          createdAt: note.createdAt,
        );
      }

      return note;
    }).toList();

    await saveNotes();
  }

  final Box box = Hive.box('notes_box');

  Future<void> loadNotes() async {
    final saved = box.get('notes');

    if (saved == null) {
      state = [];
      return;
    }

    final notes = (saved as List)
        .map(
          (e) => NoteModel(
        id: e.id,
        title: e.title,
        subject: e.subject,
        semester: e.semester,
        category: e.category,
        privateFilePath: e.privateFilePath,
        createdAt: e.createdAt,
      ),
    )
        .toList();

    notes.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    state = notes;
  }

  Future<void> saveNotes() async {
    final notes = state
        .map(
          (e) => NoteHiveModel(
        id: e.id,
        title: e.title,
        subject: e.subject,
        semester: e.semester,
        category: e.category,
        privateFilePath: e.privateFilePath,
        createdAt: e.createdAt,
      ),
    )
        .toList();

    await box.put('notes', notes);
  }

  Future<String> copyPdfToPrivateStorage(String originalPath) async {
    final appDir = await getApplicationDocumentsDirectory();

    final notesDir = Directory(
      p.join(appDir.path, 'private_notes'),
    );

    if (!await notesDir.exists()) {
      await notesDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(originalPath)}';

    final newPath = p.join(
      notesDir.path,
      fileName,
    );

    await File(originalPath).copy(newPath);

    return newPath;
  }

  Future<void> addNote({
      required String title,
      required String subject,
      required int semester,
      required String category,
      required String originalFilePath,
    }) async {

      final privatePath =
      await copyPdfToPrivateStorage(
        originalFilePath,
      );

    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subject: subject,
      semester: semester,
      category: category,
      privateFilePath: privatePath,
      createdAt: DateTime.now(),
    );

    state = [
      note,
      ...state,
    ];

    await saveNotes();
  }

  Future<void> deleteNote(String id) async {
    final note = state.firstWhere(
          (e) => e.id == id,
    );

    final file = File(note.privateFilePath);

    if (await file.exists()) {
      await file.delete();
    }

    state = state
        .where(
          (e) => e.id != id,
    )
        .toList();

    await saveNotes();
  }

  Future<void> moveNotesFromDeletedCategory({
    required String oldCategory,
    required String fallbackCategory,
  }) async {
    state = state.map((note) {
      if (note.category == oldCategory) {
        return NoteModel(
          id: note.id,
          title: note.title,
          subject: note.subject,
          semester: note.semester,
          category: fallbackCategory,
          privateFilePath: note.privateFilePath,
          createdAt: note.createdAt,
        );
      }

      return note;
    }).toList();

    await saveNotes();
  }

  List<NoteModel> filteredNotes({
    int? semester,
    String? category,
  }) {
    return state.where((note) {
      final semesterMatch =
          semester == null || note.semester == semester;

      final categoryMatch =
          category == null || note.category == category;

      return semesterMatch && categoryMatch;
    }).toList();
  }
}