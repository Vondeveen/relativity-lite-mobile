import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../db/app_db.dart';
import '../services/extractor.dart';
import '../models/document.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool working = false;
  String status = 'Pick files to import';

  Future<void> _importFiles() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['txt','pdf']);
    if (res == null) return;
    setState(()=> working=true);
    final db = await AppDb.instance;
    final sandbox = await getApplicationDocumentsDirectory();

    for (final f in res.files) {
      final path = f.path!;
      final basename = path.split(Platform.pathSeparator).last;
      final mime = path.toLowerCase().endsWith('.pdf') ? 'application/pdf' : 'text/plain';
      final dest = File('${sandbox.path}/$basename');
      await File(path).copy(dest.path);
      final text = await Extractor.extractText(dest.path, mime);
      await db.insert('documents', DocumentItem(
        title: basename,
        path: dest.path,
        mime: mime,
        text: text,
        addedAt: DateTime.now(),
      ).toMap());
      setState(()=> status = 'Imported ' + basename);
    }
    setState(()=> working=false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Documents')),
      body: Center(
        child: working ? Column(mainAxisSize: MainAxisSize.min, children:[
          const CircularProgressIndicator(), const SizedBox(height: 12), Text(status),
        ]) : FilledButton(
          onPressed: _importFiles,
          child: const Text('Pick TXT/PDF files'),
        ),
      ),
    );
  }
}
