final String tableTasklists = 'tasklists';

class TasklistFields {
  static final List<String> values = [
    /// add all fields
    id, idFolder, name, color, createDate, lastModifDate,
  ];

  static final String id = '_id';
  static final String idFolder = 'idFolder';
  static final String name = 'name';
  static final String color = 'color';
  static final String createDate = 'createDate';
  static final String lastModifDate = 'lastModifDate';
}

class Tasklist {
  final int? id;
  final int idFolder;
  final String name;
  final String color;
  final DateTime createDate;
  final DateTime lastModifDate;

  const Tasklist({
    this.id,
    required this.idFolder,
    required this.name,
    required this.color,
    required this.createDate,
    required this.lastModifDate,
  });

  Map<String, Object?> toJson() => {
        TasklistFields.id: id,
        TasklistFields.idFolder: idFolder,
        TasklistFields.name: name,
        TasklistFields.color: color,
        TasklistFields.createDate: createDate.toIso8601String(),
        TasklistFields.lastModifDate: lastModifDate.toIso8601String(),
      };

  static Tasklist fromJson(Map<String, Object?> json) => Tasklist(
        id: json[TasklistFields.id] as int?,
        idFolder: json[TasklistFields.idFolder] as int,
        name: json[TasklistFields.name] as String, 
        color: json[TasklistFields.color] as String,
        createDate: DateTime.parse(json[TasklistFields.createDate] as String),
        lastModifDate: DateTime.parse(json[TasklistFields.lastModifDate] as String),
      );

  Tasklist copy({
    int? id,
    int? idFolder,
    String? name,
    String? color,
    DateTime? createDate,
    DateTime? lastModifDate,
    String? lastModifHour,
  }) =>
      Tasklist(
          id: id ?? this.id,
          idFolder: idFolder ?? this.idFolder,
          name: name ?? this.name,
          color: color ?? this.color,
          createDate: createDate ?? this.createDate,
          lastModifDate: lastModifDate ?? this.lastModifDate,
      );
}
