const String tableTasks = 'tasks';

class TasksFields {
  static final List<String> values = [
    /// add all fields
  ];

  static const String id = '_id';
  static const String idTasklist = 'idTasklist';
  static const String position = 'position';
  static const String name = 'name';
  static const String description = 'description';
  static const String type = 'type';
  static const String finished = 'finished';
  static const String toDoNum = 'toDoNum';
  static const String doneNum = 'doneNum';
  static const String picture = 'picture';
}

class Task {
  final int? id;
  final int idTasklist;
  final int position;
  final String name;
  final String description;
  final String type;
  final bool finished;
  final int? toDoNum;
  final int? doneNum;
  final String? picture;

  const Task(
      {this.id,
      required this.idTasklist,
      required this.position,
      required this.name,
      required this.description,
      required this.type,
      required this.finished,
      this.toDoNum,
      this.doneNum,
      this.picture});

  Map<String, Object?> toJson() => {
        TasksFields.id: id,
        TasksFields.idTasklist: idTasklist,
        TasksFields.position: position,
        TasksFields.name: name,
        TasksFields.description: description,
        TasksFields.type: type,
        TasksFields.finished: finished,
        TasksFields.toDoNum: toDoNum,
        TasksFields.doneNum: doneNum,
        TasksFields.picture: picture,
      };

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TasksFields.id] as int?,
        idTasklist: json[TasksFields.idTasklist] as int,
        position: json[TasksFields.position] as int,
        name: json[TasksFields.name] as String,
        description: json[TasksFields.description] as String,
        type: json[TasksFields.type] as String,
        finished: json[TasksFields.finished] as bool,
        toDoNum: json[TasksFields.toDoNum] as int?,
        doneNum: json[TasksFields.doneNum] as int?,
        picture: json[TasksFields.picture] as String?,
      );

  Task copy({
    int? id,
    int? idTasklist,
    int? position,
    String? name,
    String? description,
    String? type,
    bool? finished,
    int? toDoNum,
    int? doneNum,
    String? picture,
  }) =>
      Task(
        id: id ?? this.id,
        idTasklist: idTasklist ?? this.idTasklist,
        position: position ?? this.position,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        finished: finished ?? this.finished,
        toDoNum: toDoNum ?? this.toDoNum,
        doneNum:  doneNum ?? this.doneNum,
        picture: picture ?? this.picture,
      );
}
