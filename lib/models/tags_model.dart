const String tableTags = 'Tags';

class TagFields {
  static final List<String> values = [
    /// add all fields
    id, name, color,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String color = 'color';
}

class Tag {
  final int? id;
  final String name;
  final String color;

  const Tag({
    this.id,
    required this.name,
    required this.color,
  });

  Map<String, Object?> toJson() => {
        TagFields.id: id,
        TagFields.name: name,
        TagFields.color: color,
      };

  static Tag fromJson(Map<String, Object?> json) => Tag(
        id: json[TagFields.id] as int?,
        name: json[TagFields.name] as String,
        color: json[TagFields.color] as String,
      );

  Tag copy({
    int? id,
    String? name,
    String? color,
    String? description,
    List<int>? tagsList,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
}
