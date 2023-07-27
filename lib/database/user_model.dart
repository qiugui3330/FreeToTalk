class User {
  final String username;
  final String email;
  String password;
  bool isLoggedIn;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn ? 1 : 0,
    };
  }
}
