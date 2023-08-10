import '../database/database_service.dart';
import '../database/user_model.dart';

class AuthenticationService {
  final dbHelper = DatabaseService.instance;

  Future<User?> getLoggedInUser() async {
    List<Map<String, dynamic>> users = await dbHelper.queryAllUsers();
    for (var user in users) {
      if (user['isLoggedIn'] == 1) {
        return User(
          username: user['username'],
          email: user['email'],
          password: user['password'],
          isLoggedIn: true,
        );
      }
    }
    return null;
  }


  Future<User?> login(String email, String password) async {
    List<Map<String, dynamic>> result = await dbHelper.queryAllUsers();

    for (var user in result) {
      if (user['email'] == email) {
        if (password == user['password']) {
          User currentUser = User(
            username: user['username'],
            email: user['email'],
            password: user['password'],
            isLoggedIn: user['isLoggedIn'] == 1,
          );

          currentUser.isLoggedIn = true;
          await dbHelper.updateUser(currentUser, user[DatabaseService.userIdColumn]);

          return currentUser;
        } else {
          throw Exception('Invalid password');
        }
      }
    }
    throw Exception('Email not found');
  }

  Future<String?> register(String username, String email, String password) async {
    List<Map<String, dynamic>> result = await dbHelper.queryAllUsers();
    for (var user in result) {
      if (user['email'] == email) {
        return 'Email is already in use';
      }
    }

    User newUser = User(
      username: username,
      email: email,
      password: password,
      isLoggedIn: false,
    );

    int inserted = await dbHelper.insertUser(newUser.toMap());
    if (inserted >= 0) {
      return null;
    } else {
      return 'Failed to register';
    }
  }
}
