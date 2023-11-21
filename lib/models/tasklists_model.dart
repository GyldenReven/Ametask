final String tableTasklists = 'tasklists';

class TasklistFields {
  static final String id = '_id';
  static final String idFolder = 'idFolder';
  static final String name = 'name';
  static final String colors = 'colors';
  static final String createDate = 'createDate';
  static final String lastModifDate = 'lastModifDate';
  static final String lastModifHour = 'lastModifHour';
}

class TasklistModel {
  final int? id;
  final int idFolder;
  final String name;
  final String colors;
  final String createDate;
  final String lastModifDate;
  final String lastModifHour;

  const TasklistModel({
    this.id,
    required this.idFolder,
    required this.name,
    required this.colors,
    required this.createDate,
    required this.lastModifDate,
    required this.lastModifHour,
  });
}