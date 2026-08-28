import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../result_import/service/pdf_text_service.dart';
import '../../result_import/service/makaut_result_parser.dart';
import '../../../core/services/pdf_import_limit_service.dart';
import '../../../core/services/rewarded_ad_service.dart';
import '../widgets/semester_summary_card.dart';
import '../../cgpa/provider/cgpa_provider.dart';
import '../../cgpa/screen/cgpa_screen.dart';
import '../provider/sgpa_provider.dart';
import '../widgets/subject_card.dart';

class SgpaScreen
    extends ConsumerStatefulWidget {
  const SgpaScreen({
    super.key,
  });

  @override
  ConsumerState<SgpaScreen>
  createState() =>
      _SgpaScreenState();
}

class _SgpaScreenState
    extends ConsumerState<SgpaScreen> {
  bool isSaved = false;

  Future<void> importResultPdf() async {
    final subjects = ref.read(sgpaProvider);
    final notifier = ref.read(sgpaProvider.notifier);
    final semester = ref.read(semesterProvider);

    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (files == null || files.isEmpty) {
      return;
    }

    final path = files.first.path;

    if (path == null) {
      return;
    }


    try {
      final extractedText =
      await PdfTextService.extractText(path);

      final parsed =
      MakautResultParser.parse(extractedText);

      await notifier.importSubjects(
        parsed.subjects,
      );

      await notifier.saveSemester(
        semester,
      );

      await PdfImportLimitService.increaseImportCount();

      ref.invalidate(cgpaProvider);

      setState(() {
        isSaved = true;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${parsed.subjects.length} subjects imported',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Import failed: $e',
            ),
          ),
        );
      }
    }
  }

  void handleImportButtonTap() {
    if (PdfImportLimitService.canImportForFree()) {
      importResultPdf();
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
        importResultPdf();
      },
      onAdUnavailable: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ad not available right now. Please try again later.',
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(
          sgpaProvider
              .notifier)
          .loadSemester(1);
    });
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final subjects =
    ref.watch(
        sgpaProvider);

    final notifier = ref.read(
      sgpaProvider.notifier,
    );

    final semester =
    ref.watch(
        semesterProvider);

    final sgpa =
    notifier.calculateSgpa();

    final totalCredits =
    notifier.totalCredits();

    final creditIndex =
    notifier
        .totalCreditPoints();

    final result =
    sgpa > 0
        ? 'PASS'
        : '--';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton:
      FloatingActionButton
          .extended(
        onPressed:
        notifier.addSubject,
        icon: const Icon(
            Icons.add),
        label: const Text(
          'Add Subject',
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color:
                    Theme.of(context)
                        .cardTheme
                        .color,

                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                    Text(
                    "Semester",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                    const Spacer(),

                    DropdownButton<int>(
                      value: semester,

                      items: List.generate(
                        8,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            'Sem ${index + 1}',
                          ),
                        ),
                      ),

                      onChanged: (value) async {
                        ref
                            .read(semesterProvider.notifier)
                            .state = value!;

                        await notifier.loadSemester(value);

                        ref.invalidate(cgpaProvider);

                        setState(() {
                          isSaved = false;
                        });
                      },
                    ),
                  ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: handleImportButtonTap,

                    icon: const Icon(
                      Icons.upload,
                    ),

                    label: const Text(
                      'Import Result PDF',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(30),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo,
                        Colors.indigo.shade400,
                      ],
                    ),

                    borderRadius:
                    BorderRadius.circular(32),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                        color: Colors.indigo
                            .withOpacity(0.25),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      const Text(
                        'Current SGPA',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        sgpa.toStringAsFixed(2),

                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        result,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                SemesterSummaryCard(
                  credits:
                  totalCredits,
                  creditIndex:
                  creditIndex,
                  sgpa: sgpa,
                  result: result,
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                    onPressed:
                        () async {
                      await notifier
                          .saveSemester(
                        semester,
                      );

                      ref.invalidate(cgpaProvider);

                      setState(() {
                        isSaved =
                        true;
                      });

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'Semester $semester saved',
                          ),
                        ),
                      );
                    },

                    icon: Icon(
                      isSaved
                          ? Icons.check
                          : Icons.save,
                    ),

                    label: Text(
                      isSaved
                          ? 'Saved'
                          : 'Save Semester',
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CgpaScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.school),
                    label: const Text('View Overall CGPA'),
                  ),
                ),

                const SizedBox(height: 20),

                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  subjects.length,

                  itemBuilder:
                      (
                      context,
                      index,
                      ) {
                    final subject =
                    subjects[
                    index];

                    return SubjectCard(
                      subject:
                      subject,
                      index:
                      index,

                      onNameChange:
                          (value) {
                        notifier
                            .updateSubjectName(
                          index,
                          value,
                        );

                        setState(() {
                          isSaved =
                          false;
                        });
                      },

                      onCreditChange:
                          (value) {
                        notifier
                            .updateCredits(
                          index,
                          value,
                        );

                        setState(() {
                          isSaved =
                          false;
                        });
                      },

                      onGradeChange:
                          (value) {
                        notifier
                            .updateGrade(
                          index,
                          value,
                        );

                        setState(() {
                          isSaved =
                          false;
                        });
                      },

                      onDelete:
                          () async {
                        notifier
                            .removeSubject(
                          index,
                        );

                        await notifier
                            .saveSemester(
                          semester,
                        );

                        ref.invalidate(cgpaProvider);

                        setState(() {
                          isSaved =
                          true;
                        });

                        if (context
                            .mounted) {
                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                              Text(
                                'Changes saved',
                              ),
                              duration:
                              Duration(
                                seconds:
                                1,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }
}