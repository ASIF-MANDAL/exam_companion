import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/cgpa_provider.dart';
import '../widgets/semester_cgpa_tile.dart';

class CgpaScreen extends ConsumerWidget {
  const CgpaScreen({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final cgpaData = ref.watch(cgpaProvider);

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('CGPA Overview'),
      ),
      body: SafeArea(
        child: cgpaData.when(
          data: (data) {
            final cgpa = data['cgpa'] as double;
            final semesters = data['semesters'] as List;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo,
                          Colors.indigo.shade300,
                        ],
                      ),
                      borderRadius:
                      BorderRadius.circular(30),
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
                          'Current CGPA',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cgpa.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 46,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Based on saved semesters',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Semester Breakdown',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (semesters.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .cardTheme
                            .color,
                        borderRadius:
                        BorderRadius.circular(24),
                      ),
                      child: Text(
                        'No semester data saved yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.65),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    ...semesters.map(
                          (e) => SemesterCgpaTile(
                        semester: e['semester'],
                        sgpa: e['sgpa'],
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, s) => Center(
            child: Text(
              e.toString(),
              style: TextStyle(
                color:
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}