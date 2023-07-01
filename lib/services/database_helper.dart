import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "ChatApp.db";
  static final _databaseVersion = 1;

  static final table = 'user';

  static final columnId = '_id';
  static final columnUsername = 'username';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  static final columnIsLoggedIn = 'isLoggedIn'; // 新增列

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnIsLoggedIn INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int rowCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
    row[columnId] = rowCount + 1;
    row[columnIsLoggedIn] = 0;
    int insertedId = await db.insert(table, row);

    // Print all rows
    List<Map<String, dynamic>> rows = await queryAllRows();
    print('All Rows:');
    rows.forEach((row) => print(row));

    return insertedId;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}