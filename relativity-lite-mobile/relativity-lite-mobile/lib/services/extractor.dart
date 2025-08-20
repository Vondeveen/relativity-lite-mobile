import 'dart:io';
import 'package:pdf_text/pdf_text.dart';

class Extractor {
  static Future<String> extractText(String path, String mime) async {
    try {
      if (mime == 'text/plain' || path.toLowerCase().endsWith('.txt')) {
        return File(path).readAsString();
      }
      if (mime == 'application/pdf' || path.toLowerCase().endsWith('.pdf')) {
        final doc = await PDFDoc.fromPath(path);
        return await doc.text; // embedded text only
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}
