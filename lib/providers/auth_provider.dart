import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login_page.dart';
import '../database/models/user_model.dart';
import '../services/authentication_service.dart';
import '../screens/chat_screen.dart';

class AuthProvider with ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  late BuildContext _context;

  set context(BuildContext context) {
    _context = context;
  }

  Future<User?> login(String email, String password) async {
    try {
      User? user = await _authService.login(email, password);
      if (user != null) {
        Navigator.of(_context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ChatScreen(user: user),
          ),
              (route) => false,
        );
      }
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<String?> register(String username, String email, String password) async {
    try {
      String? result = await _authService.register(username, email, password);
      return result;
    } catch (e) {
      throw e;
    }
  }
  Future<void> registerAndNavigate(
      String username, String email, String password, BuildContext context) async {
    String? registerResult = await register(username, email, password);
    if (registerResult == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showErrorDialog(registerResult, context);
    }
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
