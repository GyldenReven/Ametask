const String tableFolders = 'Folders';

class FolderFields {
  static final List<String> values = [
    /// add all fields
    id, name, color,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String color = 'color';
  static const String description = 'description';
  static const String tagsList = 'tagsList';
}

class Folder {
  final int? id;
  final String name;
  final String color;
  final String description;
  final List<String> tagsList;

  const Folder({
    this.id,
    required this.name,
    required this.color,
    required this.description,
    required this.tagsList,
  });

  Map<String, Object?> toJson() => {
        FolderFields.id: id,
        FolderFields.name: name,
        FolderFields.color: color,
        FolderFields.description: description,
        FolderFields.tagsList: tagsList.join("-"),
      };

  static Folder fromJson(Map<String, Object?> json) => Folder(
        id: json[FolderFields.id] as int?,
        name: json[FolderFields.name] as String,
        color: json[FolderFields.color] as String,
        description: json[FolderFields.name] as String,
        tagsList: (json[FolderFields.tagsList] as String? ?? "").split('-'),
      );

  Folder copy({
    int? id,
    String? name,
    String? color,
    String? description,
    List<String>? tagsList,
  }) =>
      Folder(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        tagsList: tagsList ?? this.tagsList,
      );
}
