import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddNoteBottomSheet extends StatefulWidget {
  final Function({
  required String title,
  required String subject,
  required int semester,
  required String category,
  required String filePath,
  }) onAdd;

  final List<String> categories;

  const AddNoteBottomSheet({
    super.key,
    required this.onAdd,
    required this.categories,
  });

  @override
  State<AddNoteBottomSheet> createState() =>
      _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState
    extends State<AddNoteBottomSheet> {
  final titleController = TextEditingController();
  final subjectController = TextEditingController();

  int selectedSemester = 1;
  String? selectedCategory;
  String? selectedFilePath;
  String? selectedFileName;

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.categories.isNotEmpty) {
      selectedCategory = widget.categories.first;
    }
  }

  Future<void> pickPdf() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (files == null || files.isEmpty) {
      return;
    }

    final file = files.first;

    setState(() {
      selectedFilePath = file.path;
      selectedFileName = file.name;
    });
  }

  void submit() {
    if (titleController.text
        .trim()
        .isEmpty ||
        subjectController.text
            .trim()
            .isEmpty ||
        selectedFilePath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter title, subject, and select a PDF',
          ),
        ),
      );

      return;
    }

    widget.onAdd(
      title:
      titleController.text.trim(),
      subject:
      subjectController.text.trim(),
      semester: selectedSemester,
      category: selectedCategory!,
      filePath: selectedFilePath!,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
          MediaQuery.of(context)
              .viewInsets
              .bottom +
              20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme
                        .onSurface
                        .withOpacity(0.25),
                    borderRadius:
                    BorderRadius.circular(
                      99,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Add Study Material',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Save notes, PDFs, PYQs and assignments securely.',
                style: TextStyle(
                  color: colorScheme
                      .onSurface
                      .withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 22),

              TextField(
                controller:
                titleController,
                decoration:
                const InputDecoration(
                  labelText: 'Title',
                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller:
                subjectController,
                decoration:
                const InputDecoration(
                  labelText: 'Subject',
                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<int>(
                value:
                selectedSemester,
                decoration:
                const InputDecoration(
                  labelText:
                  'Semester',
                  border:
                  OutlineInputBorder(),
                ),
                items: List.generate(
                  8,
                      (index) =>
                      DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                          'Semester ${index + 1}',
                        ),
                      ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedSemester =
                    value!;
                  });
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value:
                selectedCategory,
                decoration:
                const InputDecoration(
                  labelText:
                  'Category',
                  border:
                  OutlineInputBorder(),
                ),
                items: widget.categories
                    .map(
                      (category) =>
                      DropdownMenuItem(
                        value: category,
                        child:
                        Text(category),
                      ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory =
                    value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .cardTheme
                      .color,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
                child: OutlinedButton.icon(
                  style:
                  OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                  onPressed: pickPdf,
                  icon: const Icon(
                    Icons.picture_as_pdf,
                  ),
                  label: Text(
                    selectedFileName ??
                        'Choose PDF',
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                ),
              ),

              if (selectedFileName != null)
                Padding(
                  padding:
                  const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color:
                        Colors.green,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          selectedFileName!,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: TextStyle(
                            color: colorScheme
                                .onSurface
                                .withOpacity(
                              0.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child:
                ElevatedButton.icon(
                  onPressed: submit,
                  icon:
                  const Icon(Icons.save),
                  label: const Text(
                    'Save Material',
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}