import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateResult {
  final bool shouldForceUpdate;
  final String message;
  final String apkUrl;

  ForceUpdateResult({
    required this.shouldForceUpdate,
    required this.message,
    required this.apkUrl,
  });
}

class ForceUpdateService {
  static const String configUrl =
      'https://asif-mandal.github.io/exam_companion/app_config.json';

  static Future<ForceUpdateResult> checkForUpdate() async {
    try {
      final packageInfo =
          await PackageInfo.fromPlatform();

      final currentVersionCode =
          int.tryParse(packageInfo.buildNumber) ?? 1;

      final response = await http.get(
        Uri.parse(configUrl),
      );

      if (response.statusCode != 200) {
        return ForceUpdateResult(
          shouldForceUpdate: false,
          message: '',
          apkUrl: '',
        );
      }

      final data = jsonDecode(response.body);

      final latestVersionCode =
          data['latestVersionCode'] ?? 1;

      final forceUpdate =
          data['forceUpdate'] ?? false;

      final message =
          data['message'] ?? 'Please update the app.';

      final apkUrl =
          data['apkUrl'] ?? '';

      final shouldForceUpdate =
          forceUpdate &&
              currentVersionCode < latestVersionCode;

      return ForceUpdateResult(
        shouldForceUpdate: shouldForceUpdate,
        message: message,
        apkUrl: apkUrl,
      );
    } catch (_) {
      return ForceUpdateResult(
        shouldForceUpdate: false,
        message: '',
        apkUrl: '',
      );
    }
  }
}