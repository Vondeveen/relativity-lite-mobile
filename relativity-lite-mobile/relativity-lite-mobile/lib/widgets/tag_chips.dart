import 'package:flutter/material.dart';

class TagChips extends StatelessWidget {
  final List<String> values;
  final void Function(List<String>) onChanged;
  final List<String> suggestions;

  const TagChips({super.key, required this.values, required this.onChanged, this.suggestions = const []});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 8, runSpacing: -8, children: [
          for (final t in values)
            Chip(label: Text(t), onDeleted: () => onChanged([...values..remove(t)])),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Add issue…'),
              onSubmitted: (v){
                if(v.trim().isEmpty) return;
                onChanged([...values, v.trim()]);
                controller.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (v)=> onChanged([...values, if(!values.contains(v)) v]),
            itemBuilder: (_) => suggestions
              .where((s)=>!values.contains(s))
              .map((s)=>PopupMenuItem(value:s, child: Text(s))).toList(),
            child: const Icon(Icons.add_circle_outline),
          )
        ])
      ],
    );
  }
}
