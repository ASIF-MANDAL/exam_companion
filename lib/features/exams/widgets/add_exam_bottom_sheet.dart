import 'package:flutter/material.dart';

import '../model/exam_model.dart';

class AddExamBottomSheet extends StatefulWidget {
  final Function(ExamModel) onAdd;

  const AddExamBottomSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddExamBottomSheet> createState() =>
      _AddExamBottomSheetState();
}

class _AddExamBottomSheetState
    extends State<AddExamBottomSheet> {
  final subjectController = TextEditingController();
  final noteController = TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    subjectController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 22,
          bottom:
          MediaQuery.of(context).viewInsets.bottom +
              20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface
                        .withOpacity(0.25),
                    borderRadius:
                    BorderRadius.circular(99),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Add Exam',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Create a countdown and reminder for your exam.',
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 22),

              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Optional Note',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    selectedDate == null
                        ? 'Choose Exam Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (subjectController.text
                        .trim()
                        .isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter subject and date',
                          ),
                        ),
                      );
                      return;
                    }

                    widget.onAdd(
                      ExamModel(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        subjectName:
                        subjectController.text.trim(),
                        examDate: selectedDate!,
                        note: noteController.text.trim(),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}