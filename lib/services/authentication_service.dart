import 'package:chatgpt_course/services/database_helper.dart';
import 'package:chatgpt_course/models/user_model.dart';

class AuthenticationService {
  final dbHelper = DatabaseHelper.instance;

  Future<User?> login(String email, String password) async {
    List<Map<String, dynamic>> result = await dbHelper.queryAllRows();
    for (var user in result) {
      if (user['email'] == email && user['password'] == password) {
        User loggedInUser = User(
          id: user['_id'],
          username: user['username'],
          email: user['email'],
          password: user['password'],
          isLoggedIn: true,
        );
        // Update the user in the database
        await dbHelper.update(loggedInUser.toMap());
        return loggedInUser;
      }
    }
    return null;
  }

  Future<String?> register(String username, String email, String password) async {
    List<Map<String, dynamic>> result =
    await dbHelper.queryAllRows(); //Query all users
    for (var user in result) {
      if (user['email'] == email) {
        return 'Email is already in use';
      }
    }

    Map<String, dynamic> row = {
      DatabaseHelper.columnUsername: username,
      DatabaseHelper.columnEmail : email,
      DatabaseHelper.columnPassword : password
    };
    int inserted = await dbHelper.insert(row);
    return inserted == 1 ? null : 'Failed to register';
  }
}

