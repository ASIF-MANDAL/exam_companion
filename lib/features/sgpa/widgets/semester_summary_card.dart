import 'package:flutter/material.dart';

class SemesterSummaryCard extends StatelessWidget {
  final double credits;
  final double creditIndex;
  final double sgpa;
  final String result;

  const SemesterSummaryCard({
    super.key,
    required this.credits,
    required this.creditIndex,
    required this.sgpa,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(32),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo,
            Colors.indigo.shade400,
          ],
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.indigo.withOpacity(0.25),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color:
                  Colors.white.withOpacity(
                    0.15,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),

                child: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Text(
                  "Semester Summary",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _summaryTile(
            icon: Icons.menu_book,
            title: "Credits",
            value: credits
                .toStringAsFixed(1),
          ),

          _summaryTile(
            icon: Icons.calculate,
            title: "Credit Index",
            value: creditIndex
                .toStringAsFixed(1),
          ),

          _summaryTile(
            icon: Icons.school,
            title: "SGPA",
            value: sgpa
                .toStringAsFixed(2),
          ),

          _summaryTile(
            icon: result == 'PASS'
                ? Icons.check_circle
                : Icons.cancel,
            title: "Result",
            value: result,
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white70,
          ),

          const SizedBox(width: 10),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const Spacer(),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}