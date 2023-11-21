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
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const integerType = 'INTEGER NOT NULL'; 
    // final boolType = 'BOOLEAN NOT NULL';
    
    await db.execute('''
CREATE TABLE $tableTasklists (
  ${TasklistFields.id} $idType,
  ${TasklistFields.idFolder} $integerType
  ${TasklistFields.name}
)
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}