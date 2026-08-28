import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../cgpa/provider/cgpa_provider.dart';
import '../../exams/provider/exam_provider.dart';
import '../../notes/provider/category_provider.dart';
import '../../notes/provider/notes_provider.dart';
import '../../sgpa/provider/sgpa_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/banner_ad_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool notificationsEnabled = true;

  Future<bool> confirmAction({
    required String title,
    required String message,
    String buttonText = 'Clear',
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );

    return confirm == true;
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> clearSgpaData() async {
    final confirmed = await confirmAction(
      title: 'Clear SGPA/CGPA data?',
      message:
      'This will delete all saved semester SGPA/CGPA data from this device.',
    );

    if (!confirmed) return;

    await Hive.box('semester_box').clear();

    ref.invalidate(sgpaProvider);
    ref.invalidate(cgpaProvider);

    showMessage('SGPA/CGPA data cleared');
  }

  Future<void> clearExamData() async {
    final confirmed = await confirmAction(
      title: 'Clear exam data?',
      message: 'This will delete all saved exams from this device.',
    );

    if (!confirmed) return;

    await Hive.box('exam_box').clear();

    ref.invalidate(examProvider);

    showMessage('Exam data cleared');
  }

  Future<void> clearNotesData() async {
    final confirmed = await confirmAction(
      title: 'Clear notes?',
      message:
      'This will delete all saved notes and custom categories from this device.',
    );

    if (!confirmed) return;

    await Hive.box('notes_box').clear();

    ref.invalidate(notesProvider);
    ref.invalidate(categoryProvider);

    showMessage('Notes cleared successfully');
  }

  Future<void> clearAllData() async {
    final confirmed = await confirmAction(
      title: 'Clear all data?',
      message:
      'This will delete SGPA data, exams, notes, categories, and settings from this device.',
      buttonText: 'Clear All',
    );

    if (!confirmed) return;

    await Hive.box('semester_box').clear();
    await Hive.box('exam_box').clear();
    await Hive.box('notes_box').clear();

    ref.invalidate(sgpaProvider);
    ref.invalidate(cgpaProvider);
    ref.invalidate(examProvider);
    ref.invalidate(notesProvider);
    ref.invalidate(categoryProvider);

    showMessage('All app data cleared');
  }

  void showPrivacyNote() {
    showDialog(
      context: context,
      builder: (_) {
        return const AlertDialog(
          title: Text('Privacy Note'),
          content: Text(
            'Your SGPA data, exams, and notes are stored locally on your device. PDFs saved in Notes Vault are copied into private app storage and opened inside this app.',
          ),
        );
      },
    );
  }

  void showAboutApp() {
    showDialog(
      context: context,
      builder: (_) {
        return const AlertDialog(
          title: Text('About Exam Companion'),
          content: Text(
            'Exam Companion helps students manage SGPA, CGPA, exam schedules, reminders, and study materials in one place.',
          ),
        );
      },
    );
  }

  void showThemeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        final currentTheme = ref.read(themeProvider);

        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: const Text('System Default'),
                trailing: currentTheme == ThemeMode.system
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref
                      .read(themeProvider.notifier)
                      .setTheme(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light Mode'),
                trailing: currentTheme == ThemeMode.light
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref
                      .read(themeProvider.notifier)
                      .setTheme(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: currentTheme == ThemeMode.dark
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref
                      .read(themeProvider.notifier)
                      .setTheme(ThemeMode.dark);
                  Navigator.pop(context);
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
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    Colors.indigo.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Colors.indigo.withOpacity(0.25),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school,
                        size: 34,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exam Companion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Your student productivity hub',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle('Preferences'),

            _settingsTile(
              icon: Icons.dark_mode,
              title: 'Theme',
              subtitle: themeMode == ThemeMode.light
                  ? 'Light'
                  : themeMode == ThemeMode.dark
                  ? 'Dark'
                  : 'System',
              onTap: showThemeDialog,
            ),

            Container(
              margin: const EdgeInsets.only(
                bottom: 14,
              ),

              decoration: BoxDecoration(
                color:
                Theme
                    .of(context)
                    .cardTheme
                    .color,

                borderRadius:
                BorderRadius.circular(22),
              ),

              child: SwitchListTile(
                value: notificationsEnabled,

                title: Text(
                  'Exam Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface,
                  ),
                ),

                subtitle: Text(
                  'Reminder before upcoming exams',
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.65),
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });

                  showMessage(
                    value
                        ? 'Notifications enabled'
                        : 'Notifications disabled',
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            _sectionTitle('Data Management'),

            _settingsTile(
              icon: Icons.calculate,
              title: 'Clear SGPA/CGPA Data',
              subtitle: 'Delete saved semester results',
              onTap: clearSgpaData,
            ),

            _settingsTile(
              icon: Icons.calendar_month,
              title: 'Clear Exam Data',
              subtitle: 'Delete saved exams',
              onTap: clearExamData,
            ),

            _settingsTile(
              icon: Icons.folder,
              title: 'Clear Notes Data',
              subtitle: 'Delete saved notes and categories',
              onTap: clearNotesData,
            ),

            _settingsTile(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Reset the app on this device',
              danger: true,
              onTap: clearAllData,
            ),

            const SizedBox(height: 16),

            _sectionTitle('App'),

            _settingsTile(
              icon: Icons.workspace_premium,
              title: 'Upgrade to Premium',
              subtitle: 'Coming Soon',
              onTap: () {
                showMessage('Premium features are coming soon');
              },
            ),

            _settingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Note',
              subtitle: 'How your data is stored',
              onTap: showPrivacyNote,
            ),

            _settingsTile(
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Exam Companion v1.0.0',
              onTap: showAboutApp,
            ),

            const SizedBox(height: 16),

            const BannerAdWidget(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color:
          Theme
              .of(context)
              .colorScheme
              .onSurface,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final colorScheme =
        Theme
            .of(context)
            .colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color:
        Theme
            .of(context)
            .cardTheme
            .color,

        borderRadius:
        BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 5),
            color:
            colorScheme.onSurface
                .withOpacity(0.04),
          ),
        ],
      ),

      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),

        onTap: onTap,

        leading: Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: (danger
                ? Colors.red
                : Colors.indigo)
                .withOpacity(0.12),

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color:
            danger
                ? Colors.red
                : Colors.indigo,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: danger
                ? Colors.red
                : colorScheme.onSurface,
          ),
        ),

        subtitle: Padding(
          padding:
          const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: colorScheme.onSurface
                  .withOpacity(0.65),
            ),
          ),
        ),

        trailing: Icon(
          Icons.chevron_right,
          color:
          colorScheme.onSurface
              .withOpacity(0.45),
        ),
      ),
    );
  }
}