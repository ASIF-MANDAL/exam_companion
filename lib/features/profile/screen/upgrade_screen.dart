import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/premium/premium_provider.dart';

class UpgradeScreen extends ConsumerWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final isPremium =
    ref.watch(premiumProvider);

    final planText =
    isPremium ? 'Premium Active' : 'Free Plan';

    final planColor =
    isPremium ? Colors.green : Colors.orange;

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.orange.shade400,
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Exam Companion Premium',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unlock the full student productivity experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: planColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: planColor.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPremium
                            ? Icons.verified
                            : Icons.lock_outline,
                        color: planColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        planText,
                        style: TextStyle(
                          color: planColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _feature(
                  context,
                  Icons.block,
                  'Remove ads',
                ),
                _feature(
                  context,
                  Icons.note_add,
                  'Unlimited notes',
                ),
                _feature(
                  context,
                  Icons.picture_as_pdf,
                  'PDF result import',
                ),
                _feature(
                  context,
                  Icons.category,
                  'Custom categories',
                ),
                _feature(
                  context,
                  Icons.analytics,
                  'Advanced analytics',
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(premiumProvider.notifier)
                          .setPremium(!isPremium);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              !isPremium
                                  ? 'Premium enabled for testing'
                                  : 'Premium disabled for testing',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.workspace_premium,
                    ),
                    label: Text(
                      isPremium
                          ? 'Disable Test Premium'
                          : 'Enable Test Premium',
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _feature(
      BuildContext context,
      IconData icon,
      String text,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}