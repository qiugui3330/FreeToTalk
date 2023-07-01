class User {
  final int id;
  final String username;
  final String email;
  final String password;
  bool isLoggedIn;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn ? 1 : 0,
    };
  }
}