import 'package:chatgpt_course/database/models/message_model.dart';
import 'package:chatgpt_course/database/models/user_model.dart';
import 'package:chatgpt_course/database/models/wordbook_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/conversation_model.dart';

class DatabaseService {
  static final _databaseName = "my_database.db";
  static final _databaseVersion = 1;

  static final userTable = 'user';
  static final userIdColumn = '_id';
  static final usernameColumn = 'username';
  static final emailColumn = 'email';
  static final passwordColumn = 'password';
  static final isLoggedInColumn = 'isLoggedIn';

  static final wordBookTable = 'wordbook';
  static final wordBookIdColumn = 'id';
  static final wordBookUserIdColumn = 'userId';
  static final wordBookNameColumn = 'name';

  static final wordTable = 'words';
  static final wordIdColumn = 'id';
  static final wordWordColumn = 'word';
  static final wordTranslationColumn = 'translation';
  static final wordAddDateColumn = 'addDate';
  static final wordPracticeTimesColumn = 'practiceTimes';
  static final wordMasteredColumn = 'mastered';
  static final wordOriginalSentenceColumn = 'originalSentence';

  static final conversationTable = 'conversation';
  static final conversationIdColumn = 'id';
  static final conversationUserIdColumn = 'userId';
  static final conversationTypeColumn = 'type';
  static final conversationDateColumn = 'date';

  static final messageTable = 'message';
  static final messageIdColumn = 'id';
  static final messageConversationIdColumn = 'conversationId';
  static final messageContentColumn = 'content';
  static final messageIsUserMessageColumn = 'isUserMessage';

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
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        $userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $usernameColumn TEXT NOT NULL,
        $emailColumn TEXT NOT NULL,
        $passwordColumn TEXT NOT NULL,
        $isLoggedInColumn INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $wordBookTable (
        $wordBookIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $wordBookUserIdColumn INTEGER UNIQUE,
        $wordBookNameColumn TEXT NOT NULL
      )
    ''');

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

    await db.execute('''
  CREATE TABLE $conversationTable (
    $conversationIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $conversationUserIdColumn INTEGER,
    $conversationTypeColumn INTEGER NOT NULL,
    $conversationDateColumn TEXT NOT NULL,
    parameters TEXT
  )
''');

    await db.execute('''
   CREATE TABLE $messageTable (
    $messageIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $messageConversationIdColumn INTEGER,
    $messageContentColumn TEXT NOT NULL,
    $messageIsUserMessageColumn INTEGER NOT NULL
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

    await printAllRows(userTable);

    return insertedId;
  }

  Future<int> updateUser(User user, int id) async {
    Database db = await instance.database;
    return await db.update(userTable, user.toMap(),
        where: '$userIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future<int> queryUserCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $userTable')) ??
        0;
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db
        .delete(userTable, where: '$userIdColumn = ?', whereArgs: [id]);
  }

  Future<int> getCurrentUserId() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db
        .query(userTable, where: '$isLoggedInColumn = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first[userIdColumn];
    }
    return -1;
  }

  Future<void> insertWordBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> existingWordBooks = await db.query(wordBookTable, where: '$wordBookUserIdColumn = ?', whereArgs: [row[wordBookUserIdColumn]]);
    if (existingWordBooks.isEmpty) {
      await db.insert(wordBookTable, row);
      await printAllRows(wordBookTable);
    } else {
      print('User already has a WordBook.');
    }
  }

  Future<int> updateWordBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[wordBookIdColumn];
    return await db.update(wordBookTable, row,
        where: '$wordBookIdColumn = ?', whereArgs: [id]);
  }

  Future<int> deleteWordBook(int id) async {
    Database db = await instance.database;
    return await db
        .delete(wordBookTable, where: '$wordBookIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllWordBooks() async {
    Database db = await instance.database;
    return await db.query(wordBookTable);
  }

  Future<int> insertWord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int wordbookId = await getCurrentUserWordBookId();
    if (wordbookId != -1) {
      row['wordbookId'] = wordbookId;
      int insertedId = await db.insert(wordTable, row);
      await printAllRows(wordTable);
      return insertedId;
    } else {
      throw Exception('No wordbook found for the current user');
    }
  }

  Future<int> getCurrentUserWordBookId() async {
    int currentUserId = await getCurrentUserId();
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(wordBookTable,
        where: '$wordBookUserIdColumn = ?', whereArgs: [currentUserId]);
    if (result.isNotEmpty) {
      return result.first[wordBookIdColumn];
    }
    return -1;
  }

  Future<int> updateWord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[wordIdColumn];
    return await db
        .update(wordTable, row, where: '$wordIdColumn = ?', whereArgs: [id]);
  }

  Future<int> deleteWord(int id) async {
    Database db = await instance.database;
    return await db
        .delete(wordTable, where: '$wordIdColumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await instance.database;
    return await db.query(wordTable);
  }

  Future<List<String>> getWordsFromDaysAgo(List<int> daysAgoList) async {
    List<String> words = [];
    Database db = await instance.database;
    List<Map<String, dynamic>> allWords = await db.query(wordTable);

    DateTime now = DateTime.now();
    for (var word in allWords) {
      DateTime addDate = DateTime.parse(word[wordAddDateColumn]);
      int daysAgo = now.difference(addDate).inDays;

      if (daysAgoList.contains(daysAgo)) {
        words.add(word[wordWordColumn]);
      }
    }

    return words;
  }

  Future<void> createWordBook(int userId) async {
    String name = await getUserName(userId) + "'s wordbook";
    WordBook wordBook = WordBook(userId: userId, name: name);
    await insertWordBook(wordBook.toMap());
  }

  Future<String> getUserName(int userId) async {
    Database db = await instance.database;
    var result = await db.query(userTable,
        where: '$userIdColumn = ?',
        whereArgs: [userId],
        columns: [usernameColumn]);
    if (result.isNotEmpty) {
      return result.first[usernameColumn] as String;
    } else {
      throw Exception('User with id $userId not found');
    }
  }

  Future<int> insertConversation(Conversation conversation) async {
    Database db = await instance.database;
    int id = await db.insert(conversationTable, conversation.toMap());
    await printAllRows(conversationTable);
    return id;
  }

  Future<void> printAllRows(String tableName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(tableName);
    print('All rows in the $tableName:');
    for (var row in results) {
      print(row);
    }
  }

  Future<int> insertMessage(Message message) async {
    Database db = await instance.database;
    var map = message.toMap();
    map[messageIsUserMessageColumn] = message.isUserMessage ? 1 : 0;
    int id = await db.insert(messageTable, map);
    await printAllRows(messageTable);
    return id;
  }

  Future<List<Map<String, dynamic>>> getMessagesByConversationId(
      int conversationId) async {
    Database db = await database;
    return await db.query(
      messageTable,
      where: '$messageConversationIdColumn = ?',
      whereArgs: [conversationId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllWordsSortedByDate() async {
    Database db = await instance.database;
    return await db.query(wordTable, orderBy: '$wordAddDateColumn DESC');
  }
}
