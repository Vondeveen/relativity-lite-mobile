import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/document.dart';
import '../db/app_db.dart';
import '../widgets/tag_chips.dart';

class DocumentScreen extends StatefulWidget {
  final DocumentItem item;
  const DocumentScreen({super.key, required this.item});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late bool privilege;
  bool? responsive;
  late List<String> issues;

  @override
  void initState(){
    super.initState();
    privilege = widget.item.privilege;
    responsive = widget.item.responsive;
    issues = [...widget.item.issues];
  }

  Future<void> _save() async {
    final db = await AppDb.instance;
    await db.update('documents', {
      'privilege': privilege ? 1 : 0,
      'responsive': responsive==null? null : (responsive! ? 1 : 0),
      'issues': issues.join('\u0001'),
    }, where: 'id = ?', whereArgs: [widget.item.id]);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(children:[
              Expanded(child: DropdownButtonFormField<bool?>(
                value: responsive,
                decoration: const InputDecoration(labelText: 'Responsiveness'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Undetermined')),
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: (v)=> setState(()=> responsive=v),
              )),
              const SizedBox(width: 12),
              Expanded(child: SwitchListTile(
                title: const Text('Privilege'),
                contentPadding: EdgeInsets.zero,
                value: privilege,
                onChanged: (v)=> setState(()=> privilege=v),
              )),
            ]),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: Text('Issues', style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(height: 4),
            TagChips(
              values: issues,
              onChanged: (v)=> setState(()=> issues=[...v]),
              suggestions: const ['Confidentiality','Damages','Privilege','Contract','Competition','Email Threading'],
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.item.text.isEmpty ? '(No extractable text)' : widget.item.text,
                  style: const TextStyle(fontFamily: 'monospace', height: 1.3),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: _save, child: const Text('Save')))
          ],
        ),
      ),
    );
  }
}
