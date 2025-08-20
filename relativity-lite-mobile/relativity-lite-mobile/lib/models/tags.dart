class TagSet {
  bool? responsive; // yes/no/undetermined(null)
  bool privilege = false;
  final List<String> issues; // freeform issue labels

  TagSet({this.responsive, this.privilege = false, List<String>? issues})
      : issues = issues ?? [];

  Map<String, dynamic> toJson() => {
        'responsive': responsive,
        'privilege': privilege,
        'issues': issues,
      };

  static TagSet fromJson(Map<String, dynamic> j) => TagSet(
        responsive: j['responsive'],
        privilege: j['privilege'] ?? false,
        issues: (j['issues'] as List?)?.cast<String>() ?? [],
      );
}
