const String tableTasklists = 'tasklists';

class TasklistFields {
  static final List<String> values = [
    /// add all fields
    id, idFolder, name, color, description, createDate, lastModifDate, tagsList,
  ];

  static const String id = '_id';
  static const String idFolder = 'idFolder';
  static const String name = 'name';
  static const String color = 'color';
  static const String description = 'description';
  static const String createDate = 'createDate';
  static const String lastModifDate = 'lastModifDate';
  static const String tagsList = 'tagsList';
}

class Tasklist {
  final int? id;
  final int idFolder;
  final String name;
  final String color;
  final String description;
  final DateTime createDate;
  final DateTime lastModifDate;
  final List<String> tagsList;

  const Tasklist({
    this.id,
    required this.idFolder,
    required this.name,
    required this.color,
    required this.description,
    required this.createDate,
    required this.lastModifDate,
    required this.tagsList,
  });

  Map<String, Object?> toJson() => {
        TasklistFields.id: id,
        TasklistFields.idFolder: idFolder,
        TasklistFields.name: name,
        TasklistFields.color: color,
        TasklistFields.description: description,
        TasklistFields.createDate: createDate.toIso8601String(),
        TasklistFields.lastModifDate: lastModifDate.toIso8601String(),
        TasklistFields.tagsList: tagsList.join("-"),
      };

  static Tasklist fromJson(Map<String, Object?> json) { 
    print(json);
    return Tasklist(
      id: json[TasklistFields.id] as int?,
      idFolder: json[TasklistFields.idFolder] as int,
      name: json[TasklistFields.name] as String,
      color: json[TasklistFields.color] as String,
      description: json[TasklistFields.description] as String,
      createDate: DateTime.parse(json[TasklistFields.createDate] as String),
      lastModifDate:
          DateTime.parse(json[TasklistFields.lastModifDate] as String),
      tagsList: (json[TasklistFields.tagsList] as String? ?? "").split('-'),
    );}

  Tasklist copy({
    int? id,
    int? idFolder,
    String? name,
    String? color,
    String? description,
    DateTime? createDate,
    DateTime? lastModifDate,
    List<String>? tagsList,
  }) =>
      Tasklist(
        id: id ?? this.id,
        idFolder: idFolder ?? this.idFolder,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        createDate: createDate ?? this.createDate,
        lastModifDate: lastModifDate ?? this.lastModifDate,
        tagsList: tagsList ?? this.tagsList,
      );
}
