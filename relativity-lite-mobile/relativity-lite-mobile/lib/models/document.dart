class DocumentItem {
  final int? id; // sqlite id
  final String title;
  final String path; // sandbox copy path
  final String mime;
  final String text; // extracted text
  final DateTime addedAt;
  final bool privilege;
  final bool? responsive;
  final List<String> issues;

  DocumentItem({
    this.id,
    required this.title,
    required this.path,
    required this.mime,
    required this.text,
    required this.addedAt,
    this.privilege = false,
    this.responsive,
    List<String>? issues,
  }) : issues = issues ?? [];

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'path': path,
        'mime': mime,
        'text': text,
        'added_at': addedAt.toIso8601String(),
        'privilege': privilege ? 1 : 0,
        'responsive': responsive == null ? null : (responsive! ? 1 : 0),
        'issues': issues.join('\u0001'),
      };

  static DocumentItem fromMap(Map<String, Object?> m) => DocumentItem(
        id: m['id'] as int?,
        title: m['title'] as String,
        path: m['path'] as String,
        mime: m['mime'] as String,
        text: m['text'] as String,
        addedAt: DateTime.parse(m['added_at'] as String),
        privilege: (m['privilege'] as int) == 1,
        responsive: m['responsive'] == null
            ? null
            : ((m['responsive'] as int) == 1),
        issues: (m['issues'] as String?)?.split('\u0001') ?? [],
      );
}
