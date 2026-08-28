import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, Asif 👋",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Ready for exams today?",
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}