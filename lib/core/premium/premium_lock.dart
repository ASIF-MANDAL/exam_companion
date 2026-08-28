import 'package:flutter/material.dart';

class PremiumLock extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onUpgrade;

  const PremiumLock({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.amber.withOpacity(0.45),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color:
            colorScheme.onSurface.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.workspace_premium,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.65),
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            onPressed: onUpgrade,
            icon: const Icon(Icons.lock_open),
            label: const Text('Upgrade to Premium'),
          ),
        ],
      ),
    );
  }
}