import 'package:chatgpt_course/services/database_helper.dart';
import 'package:chatgpt_course/services/user_model.dart';

class AuthenticationService {
  final dbHelper = DatabaseHelper.instance;

  Future<User?> login(String email, String password) async {
    List<Map<String, dynamic>> result = await dbHelper.queryAllRows();
    for (var user in result) {
      if (user['email'] == email && user['password'] == password) {
        return User(
          id: user['_id'], // Use 'user['_id']' instead of 'user['id']'
          email: user['email'],
          password: user['password'],
        );
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
