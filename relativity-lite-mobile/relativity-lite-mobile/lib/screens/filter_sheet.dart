import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final bool? initialResponsive;
  final bool initialPrivilege;
  final void Function(bool? responsive, bool privilege) onChanged;
  const FilterSheet({super.key, required this.initialResponsive, required this.initialPrivilege, required this.onChanged});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool? responsive;
  bool privilege=false;

  @override
  void initState(){
    super.initState();
    responsive = widget.initialResponsive;
    privilege = widget.initialPrivilege;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<bool?>(
              value: responsive,
              items: const [
                DropdownMenuItem(value: null, child: Text('Any Responsiveness')),
                DropdownMenuItem(value: true, child: Text('Responsive = Yes')),
                DropdownMenuItem(value: false, child: Text('Responsive = No')),
              ],
              onChanged: (v)=> setState(()=> responsive=v),
            ),
            SwitchListTile(
              value: privilege,
              onChanged: (v)=> setState(()=> privilege=v),
              title: const Text('Privilege only'),
            ),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: (){ widget.onChanged(responsive, privilege); Navigator.pop(context); },
              child: const Text('Apply'),
            ))
          ],
        ),
      ),
    );
  }
}
