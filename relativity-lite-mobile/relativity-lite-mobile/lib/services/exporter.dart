import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class Exporter {
  static Future<File> exportJson(List<DocumentItem> docs) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/coded_set.json');
    final data = docs.map((d) => {
          'title': d.title,
          'path': d.path,
          'mime': d.mime,
          'responsive': d.responsive,
          'privilege': d.privilege,
          'issues': d.issues,
          'added_at': d.addedAt.toIso8601String(),
        }).toList();
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    return file;
  }
}
