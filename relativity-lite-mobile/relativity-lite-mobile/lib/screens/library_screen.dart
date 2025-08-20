import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../db/app_db.dart';
import '../models/document.dart';
import 'import_screen.dart';
import 'document_screen.dart';
import 'filter_sheet.dart';
import '../services/exporter.dart';
import 'package:share_plus/share_plus.dart';

class LibraryModel extends ChangeNotifier {
  List<DocumentItem> items = [];
  String query = '';
  bool? responsive;
  bool privilegeOnly = false;

  Future<void> refresh() async {
    final db = await AppDb.instance;
    final where = <String>[];
    final args = <Object?>[];
    if (query.isNotEmpty) {
      where.add('text LIKE ?');
      args.add('%' + query.replaceAll('%', '\%') + '%');
    }
    if (responsive != null) {
      where.add('responsive = ?');
      args.add(responsive! ? 1 : 0);
    }
    if (privilegeOnly) where.add('privilege = 1');

    final rows = await db.query(
      'documents',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'added_at DESC',
    );
    items = rows.map(DocumentItem.fromMap).toList();
    notifyListeners();
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryModel()..refresh(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Relativity‑lite Mobile'),
          actions: [
            Builder(builder: (ctx)=>IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () async {
                final model = Provider.of<LibraryModel>(ctx, listen:false);
                await showModalBottomSheet(
                  context: ctx,
                  builder: (_) => FilterSheet(
                    initialResponsive: model.responsive,
                    initialPrivilege: model.privilegeOnly,
                    onChanged: (resp, priv){
                      model.responsive = resp; model.privilegeOnly = priv; model.refresh();
                    },
                  ),
                );
              },
            )),
            Builder(builder: (ctx)=>IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: () async {
                final model = Provider.of<LibraryModel>(ctx, listen:false);
                final file = await Exporter.exportJson(model.items);
                await Share.shareXFiles([XFile(file.path)], text: 'Coded set export');
              },
            )),
          ],
        ),
        body: Column(children:[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Keyword search…'),
              onChanged: (v){
                final m = Provider.of<LibraryModel>(context, listen:false);
                m.query = v; m.refresh();
              },
            ),
          ),
          Expanded(
            child: Consumer<LibraryModel>(
              builder: (_, m, __) => m.items.isEmpty
                ? const Center(child: Text('No documents yet. Tap + to import.'))
                : ListView.separated(
                    itemCount: m.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i){
                      final d = m.items[i];
                      return ListTile(
                        title: Text(d.title),
                        subtitle: Text('${d.mime} • ${d.addedAt.toLocal()}'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children:[
                          if(d.responsive == true) const Icon(Icons.check_circle, color: Colors.green),
                          if(d.privilege) const Icon(Icons.lock_outline),
                        ]),
                        onTap: () async {
                          await Navigator.push(ctx, MaterialPageRoute(builder: (_)=> DocumentScreen(item: d)));
                          Provider.of<LibraryModel>(ctx, listen:false).refresh();
                        },
                      );
                    },
                  ),
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_)=> const ImportScreen()));
            // refresh afterward
            // ignore: use_build_context_synchronously
            Provider.of<LibraryModel>(context, listen:false).refresh();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
