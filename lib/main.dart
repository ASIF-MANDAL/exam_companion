import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/force_update_service.dart';
import 'core/screen/update_required_screen.dart';
import 'features/exams/model/exam_hive_model.dart';
import 'features/notes/model/note_hive_model.dart';
import 'features/sgpa/model/subject_hive_model.dart';
import 'navigation/bottom_nav_screen.dart';
import 'core/services/rewarded_ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(
    SubjectHiveModelAdapter(),
  );

  Hive.registerAdapter(
    ExamHiveModelAdapter(),
  );

  Hive.registerAdapter(
    NoteHiveModelAdapter(),
  );

  await Hive.openBox('semester_box');
  await Hive.openBox('exam_box');
  await Hive.openBox('notes_box');
  await Hive.openBox('settings_box');

  await NotificationService.init();
  await MobileAds.instance.initialize();
  RewardedAdService.loadRewardedAd();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final themeMode =
    ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam Companion',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: FutureBuilder(
        future: ForceUpdateService.checkForUpdate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final result = snapshot.data;

          if (result != null &&
              result.shouldForceUpdate) {
            return UpdateRequiredScreen(
              message: result.message,
              apkUrl: result.apkUrl,
            );
          }

          return const BottomNavScreen();
        },
      ),
    );
  }
}