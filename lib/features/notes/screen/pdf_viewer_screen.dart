import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String filePath;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  State<PdfViewerScreen> createState() =>
      _PdfViewerScreenState();
}

class _PdfViewerScreenState
    extends State<PdfViewerScreen> {
  static const MethodChannel _channel =
  MethodChannel('exam_companion/secure_screen');

  @override
  void initState() {
    super.initState();
    _setSecureScreen(true);
  }

  Future<void> _setSecureScreen(bool enabled) async {
    try {
      await _channel.invokeMethod(
        enabled ? 'enable' : 'disable',
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _setSecureScreen(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PDFView(
        filePath: widget.filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}