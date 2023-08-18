import 'package:flutter/cupertino.dart';

import '../database/models/user_model.dart';
import '../services/authentication_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();

  Future<User?> login(String email, String password) async {
    try {
      User? user = await _authService.login(email, password);
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
}
