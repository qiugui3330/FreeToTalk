import 'package:flutter/material.dart';
import 'package:chatgpt_course/services/authentication_service.dart';
import 'package:flutter/services.dart';
import 'package:chatgpt_course/screens/chat_screen.dart';
import 'package:chatgpt_course/auth/register_page.dart';
import 'package:chatgpt_course/widgets/CustomTextField.dart';

// Defining a stateless widget for the login page
class LoginPage extends StatelessWidget {
  // Initializing controllers for email and password text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Initializing an instance of the authentication service
  final authService = AuthenticationService();

  // Building the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Defining the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // Defining the body of the scaffold
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displaying the login text
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Creating a custom text field for email input
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              SizedBox(height: 20),
              // Creating a custom text field for password input
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Creating a login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Login', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  // Attempting to login the user
                  var user = await authService.login(
                      emailController.text, passwordController.text);
                  if (user != null) {
                    // If login is successful, navigate to the chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: user),
                      ),
                    );
                  } else {
                    // If login fails, show an error message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Invalid credentials"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              // Providing a link to the registration page
              GestureDetector(
                child: Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // Navigate to the registration page when the text is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}