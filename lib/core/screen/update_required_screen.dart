import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredScreen extends StatelessWidget {
  final String message;
  final String apkUrl;

  const UpdateRequiredScreen({
    super.key,
    required this.message,
    required this.apkUrl,
  });

  Future<void> openUpdateLink() async {
    final uri = Uri.parse(apkUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.system_update,
                size: 90,
                color: colorScheme.primary,
              ),

              const SizedBox(height: 24),

              Text(
                'Update Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(0.65),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: openUpdateLink,
                  icon: const Icon(Icons.download),
                  label: const Text('Update Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}