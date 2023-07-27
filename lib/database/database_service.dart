import 'package:chatgpt_course/database/user_model.dart';
import 'package:chatgpt_course/database/word_model.dart';
import 'package:chatgpt_course/database/wordbook_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final _databaseName = "my_database.db";
  static final _databaseVersion = 1;

  // User table
  static final userTable = 'user';
  static final userIdColumn = '_id';
  static final usernameColumn = 'username';
  static final emailColumn = 'email';
  static final passwordColumn = 'password';
  static final isLoggedInColumn = 'isLoggedIn';

  // WordBook table
  static final wordBookTable = 'wordbook';
  static final wordBookIdColumn = 'id';
  static final wordBookUserIdColumn = 'userId';
  static final wordBookNameColumn = 'name';

  // Word table
  static final wordTable = 'words';
  static final wordIdColumn = 'id';
  static final wordWordColumn = 'word';
  static final wordTranslationColumn = 'translation';
  static final wordAddDateColumn = 'addDate';
  static final wordPracticeTimesColumn = 'practiceTimes';
  static final wordMasteredColumn = 'mastered';
  static final wordOriginalSentenceColumn = 'originalSentence';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create user table
    await db.execute('''
      CREATE TABLE $userTable (
        $userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $usernameColumn TEXT NOT NULL,
        $emailColumn TEXT NOT NULL,
        $passwordColumn TEXT NOT NULL,
        $isLoggedInColumn INTEGER NOT NULL
      )
    ''');

    // Create wordbook table
    await db.execute('''
      CREATE TABLE $wordBookTable (
        $wordBookIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $wordBookUserIdColumn INTEGER,
        $wordBookNameColumn TEXT NOT NULL
      )
    ''');

    // Create word table
    await db.execute('''
      CREATE TABLE $wordTable (
        $wordIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $wordWordColumn TEXT NOT NULL,
        $wordTranslationColumn TEXT NOT NULL,
        $wordAddDateColumn TEXT NOT NULL,
        $wordPracticeTimesColumn INTEGER NOT NULL,
        $wordMasteredColumn INTEGER NOT NULL,
        $wordOriginalSentenceColumn TEXT NOT NULL,
        wordbookId INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    row[isLoggedInColumn] = 0;

    User user = User(
      username: row[usernameColumn],
      email: row[emailColumn],
      password: row[passwordColumn],
    );

    row[passwordColumn] = user.password;

    int insertedId = await db.insert(userTable, row);

    await createWordBook(insertedId);

    List<Map<String, dynamic>> rows = await queryAllUsers();
    print('All Users:');
    rows.forEach((row) => print(row));

    return insertedId;
  }

  // The rest of your original methods go here, removing any logic related to manually incrementing the id value

  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[userIdColumn];
    return await db.update(userTable, row, where: '$userIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future<int> queryUserCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $userTable')) ?? 0;
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(userTable, where: '$userIdColumn = ?', whereArgs: [id]);
  }

  Future<int> getCurrentUserId() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(userTable, where: '$isLoggedInColumn = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first[userIdColumn];
    }
    return -1;
  }
  Future<void> insertWordBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(wordBookTable, row);
    await printAllWordBooks();
  }

  Future<int> updateWordBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[wordBookIdColumn];
    return await db.update(wordBookTable, row, where: '$wordBookIdColumn = ?', whereArgs: [id]);
  }

  Future<int> deleteWordBook(int id) async {
    Database db = await instance.database;
    return await db.delete(wordBookTable, where: '$wordBookIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllWordBooks() async {
    Database db = await instance.database;
    return await db.query(wordBookTable);
  }

  Future<int> insertWord(Map<String, dynamic> row) async {
    Database db = await instance.database;

    // get wordbookId of the current user
    int wordbookId = await getCurrentUserWordBookId();

    // If a wordbook is found for the current user
    if (wordbookId != -1) {
      row['wordbookId'] = wordbookId; // Add wordbookId to the row
      int insertedId = await db.insert(wordTable, row);
      await printAllWords();
      return insertedId;
    } else {
      throw Exception('No wordbook found for the current user');
    }
  }

  Future<int> getCurrentUserWordBookId() async {
    int currentUserId = await getCurrentUserId();
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(wordBookTable, where: '$wordBookUserIdColumn = ?', whereArgs: [currentUserId]);
    if (result.isNotEmpty) {
      return result.first[wordBookIdColumn];
    }
    return -1;
  }

  Future<void> printAllWords() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(wordTable);
    print('All words in the database:');
    for (var row in results) {
      print(row);
    }
  }

  Future<int> updateWord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[wordIdColumn];
    return await db.update(wordTable, row, where: '$wordIdColumn = ?', whereArgs: [id]);
  }

  Future<int> deleteWord(int id) async {
    Database db = await instance.database;
    return await db.delete(wordTable, where: '$wordIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await instance.database;
    return await db.query(wordTable);
  }

  Future<void> createWordBook(int userId) async {
    String name = await getUserName(userId) + "'s wordbook";
    WordBook wordBook = WordBook(userId: userId, name: name);
    await insertWordBook(wordBook.toMap());
  }

  Future<void> printAllWordBooks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(wordBookTable);
    print('All wordbooks in the database:');
    for (var row in results) {
      print(row);
    }
  }

  Future<String> getUserName(int userId) async {
    Database db = await instance.database;
    var result = await db.query(userTable, where: '$userIdColumn = ?', whereArgs: [userId], columns: [usernameColumn]);
    if (result.isNotEmpty) {
      return result.first[usernameColumn] as String;
    } else {
      throw Exception('User with id $userId not found');
    }
  }
}