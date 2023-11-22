import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ametask/models/tasklists_model.dart';

class AmetaskDatabase {
  static final AmetaskDatabase instance = AmetaskDatabase._init();

  static Database? _database;

  AmetaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ametaskDatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
    // onCreate execute la fonction lors de la creation de la db
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL'; 
    // final boolType = 'BOOLEAN NOT NULL';
    
    await db.execute('''
CREATE TABLE $tableTasklists (
  ${TasklistFields.id} $idType,
  ${TasklistFields.idFolder} $integerType,
  ${TasklistFields.name} $textType,
  ${TasklistFields.color} $textType,
  ${TasklistFields.createDate} $textType,
  ${TasklistFields.lastModifDate} $textType,
)
''');
  }

  Future<Tasklist> createTasklist(Tasklist tasklist) async {
    final db = await instance.database;

    // autre solution (voir la vidéo à 13 min)
    final id = await db.insert(tableTasklists, tasklist.toJson());
    return tasklist.copy(id : id);
  }

  Future<Tasklist> readTasklist(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasklists, 
      columns: TasklistFields.values,
      where: '${TasklistFields.id} = ?',
      whereArgs: [id],   // replace the '?' (prevent sql injection attacks)
    );
    if (maps.isNotEmpty) {
      return Tasklist.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Tasklist>> readAllTasklists() async {
    final db = await instance.database;

    final orderBy = '${TasklistFields.createDate} ASC';

    // autre méthode avec le rawQuery
    final result = await db.query(tableTasklists, orderBy: orderBy);

    return result.map((json) => Tasklist.fromJson(json)).toList();
  }

  Future updateTasklist(Tasklist tasklist) async {
    final db = await instance.database;

    return db.update(
      tableTasklists,
      tasklist.toJson(),
      where: '${TasklistFields.id} = ?',
      whereArgs: [tasklist.id],
    ); 
  }

  Future<int> deleteTasklist(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTasklists,
      where: '${TasklistFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}