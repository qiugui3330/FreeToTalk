// Defining a User class
class User {
  // Defining properties for the class
  final int id;
  final String username;
  final String email;
  final String password;
  bool isLoggedIn;

  // Defining a constructor for the class
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  // Defining a method to convert an instance of the class to a map
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
