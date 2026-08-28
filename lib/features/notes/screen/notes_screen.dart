import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/category_limit_service.dart';
import '../../../core/services/rewarded_ad_service.dart';
import '../provider/category_provider.dart';
import '../provider/notes_provider.dart';
import '../widgets/add_note_bottom_sheet.dart';
import '../widgets/note_card.dart';
import 'pdf_viewer_screen.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() =>
      _NotesScreenState();
}

class _NotesScreenState
    extends ConsumerState<NotesScreen> {
  int? selectedSemester;
  String selectedCategory = 'All';
  String searchQuery = '';

  void handleAddCategoryTap() {
    if (CategoryLimitService.canCreateForFree()) {
      showAddCategoryDialog();
      return;
    }

    if (!RewardedAdService.isReady) {
      RewardedAdService.loadRewardedAd();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ad is loading. Please try again in a few seconds.',
          ),
        ),
      );

      return;
    }

    RewardedAdService.showRewardedAd(
      onRewardEarned: () {
        if (!mounted) return;

        showAddCategoryDialog();
      },
      onAdUnavailable: () {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ad is not available right now. Please try again later.',
            ),
          ),
        );
      },
    );
  }

  void showAddNoteSheet(
      List<String> customCategories,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return AddNoteBottomSheet(
          categories: customCategories,
          onAdd: ({
            required title,
            required subject,
            required semester,
            required category,
            required filePath,
          }) async {
            try {
              await ref
                  .read(notesProvider.notifier)
                  .addNote(
                title: title,
                subject: subject,
                semester: semester,
                category: category,
                originalFilePath: filePath,
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e
                        .toString()
                        .replaceAll('Exception: ', ''),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  void showAddCategoryDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization:
            TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Category name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final categoryName =
                controller.text.trim();

                if (categoryName.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a category name.',
                      ),
                    ),
                  );
                  return;
                }

                await ref
                    .read(categoryProvider.notifier)
                    .addCategory(categoryName);

                await CategoryLimitService
                    .increaseCategoryCount();

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showRenameDialog(note) {
    final controller = TextEditingController(
      text: note.title,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rename Material'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'New title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTitle =
                controller.text.trim();

                if (newTitle.isEmpty) {
                  return;
                }

                await ref
                    .read(notesProvider.notifier)
                    .renameNote(
                  id: note.id,
                  newTitle: newTitle,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void showMoveCategorySheet(
      note,
      List<String> customCategories,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: customCategories.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No categories available',
              ),
            ),
          )
              : Wrap(
            children: customCategories
                .map(
                  (category) => ListTile(
                leading: const Icon(
                  Icons.category,
                ),
                title: Text(category),
                trailing:
                note.category == category
                    ? const Icon(
                  Icons.check,
                )
                    : null,
                onTap: () async {
                  Navigator.pop(
                    sheetContext,
                  );

                  await ref
                      .read(
                    notesProvider
                        .notifier,
                  )
                      .moveNoteCategory(
                    id: note.id,
                    newCategory:
                    category,
                  );
                },
              ),
            )
                .toList(),
          ),
        );
      },
    );
  }

  void showCategoryActions(
      String category,
      ) {
    if (category == 'All') {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:
      Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(
                  'Rename Category',
                ),
                onTap: () {
                  Navigator.pop(sheetContext);

                  showRenameCategoryDialog(
                    category,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete Category',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  await ref
                      .read(notesProvider.notifier)
                      .moveNotesFromDeletedCategory(
                    oldCategory: category,
                    fallbackCategory: 'Notes',
                  );

                  await ref
                      .read(
                    categoryProvider.notifier,
                  )
                      .deleteCategory(category);

                  if (selectedCategory ==
                      category) {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showRenameCategoryDialog(
      String oldCategory,
      ) {
    final controller = TextEditingController(
      text: oldCategory,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Rename Category',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'New category name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName =
                controller.text.trim();

                if (newName.isEmpty) {
                  return;
                }

                await ref
                    .read(
                  categoryProvider.notifier,
                )
                    .renameCategory(
                  oldName: oldCategory,
                  newName: newName,
                );

                if (selectedCategory ==
                    oldCategory) {
                  setState(() {
                    selectedCategory = newName;
                  });
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void showNoteActions(
      note,
      List<String> customCategories,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.open_in_new,
                ),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(sheetContext);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PdfViewerScreen(
                            title: note.title,
                            filePath:
                            note.privateFilePath,
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showRenameDialog(note);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.category,
                ),
                title: const Text(
                  'Move Category',
                ),
                onTap: () {
                  Navigator.pop(sheetContext);

                  showMoveCategorySheet(
                    note,
                    customCategories,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  await ref
                      .read(notesProvider.notifier)
                      .deleteNote(note.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);

    final customCategories =
    ref.watch(categoryProvider);

    final categories = [
      'All',
      ...customCategories,
    ];

    final filteredNotes =
    notes.where((note) {
      final semesterMatch =
          selectedSemester == null ||
              note.semester == selectedSemester;

      final categoryMatch =
          selectedCategory == 'All' ||
              note.category == selectedCategory;

      final query =
      searchQuery.toLowerCase().trim();

      final searchMatch = query.isEmpty ||
          note.title
              .toLowerCase()
              .contains(query) ||
          note.subject
              .toLowerCase()
              .contains(query) ||
          note.category
              .toLowerCase()
              .contains(query);

      return semesterMatch &&
          categoryMatch &&
          searchMatch;
    }).toList();

    final colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
      Theme.of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notes Vault'),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          showAddNoteSheet(
            customCategories,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add PDF'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Organized Study Materials',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Manage notes, PDFs, PYQs and assignments',
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText:
                  'Search by title, subject, category...',
                  prefixIcon:
                  const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context)
                      .cardTheme
                      .color,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<int?>(
                value: selectedSemester,
                decoration:
                const InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text(
                      'All Semesters',
                    ),
                  ),
                  ...List.generate(
                    8,
                        (index) =>
                        DropdownMenuItem<int?>(
                          value: index + 1,
                          child: Text(
                            'Sem ${index + 1}',
                          ),
                        ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed:
                  handleAddCategoryTap,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Category',
                  ),
                ),
              ),

              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection:
                  Axis.horizontal,
                  children:
                  categories.map((category) {
                    final selected =
                        selectedCategory ==
                            category;

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        right: 10,
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          showCategoryActions(
                            category,
                          );
                        },
                        child: ChoiceChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : colorScheme
                                  .onSurface,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          selected: selected,
                          selectedColor:
                          Colors.indigo,
                          backgroundColor:
                          Theme.of(context)
                              .cardTheme
                              .color,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory =
                                  category;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '${filteredNotes.length} material(s) found',
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.65),
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              filteredNotes.isEmpty
                  ? SizedBox(
                height: 270,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 70,
                        color: colorScheme
                            .onSurface
                            .withOpacity(
                          0.35,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'No study materials found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight
                              .bold,
                          color: colorScheme
                              .onSurface,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Tap + Add PDF to save your notes',
                        style: TextStyle(
                          color: colorScheme
                              .onSurface
                              .withOpacity(
                            0.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount:
                filteredNotes.length,
                itemBuilder:
                    (context, index) {
                  final note =
                  filteredNotes[index];

                  return NoteCard(
                    note: note,
                    onOpen: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PdfViewerScreen(
                                title:
                                note.title,
                                filePath: note
                                    .privateFilePath,
                              ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showNoteActions(
                        note,
                        customCategories,
                      );
                    },
                    onDelete: () async {
                      await ref
                          .read(
                        notesProvider
                            .notifier,
                      )
                          .deleteNote(
                        note.id,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}