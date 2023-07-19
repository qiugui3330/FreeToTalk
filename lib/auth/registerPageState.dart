import 'package:chatgpt_course/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication_service.dart';
import 'login_page.dart';

// Defining a stateful widget for the registration page
class RegisterPageState extends State<RegisterPage> {
  // Initializing controllers for username, email, password, and confirm password text fields
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // Initializing a global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Building the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Defining the app bar
      appBar: AppBar(
        title: Text("Register"),
      ),
      // Defining the body of the scaffold
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    // Creating text fields for username, email, password, and confirm password with validation
                    TextFormField(
                      controller: _username,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (value != _password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    // Creating a register button
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Defining the function to submit the form
  void _submitForm() async {
    // Validating the form
    if (_formKey.currentState!.validate()) {
      // Attempting to register the user
      var authService = Provider.of<AuthenticationService>(context, listen: false);
      var error = await authService.register(_username.text, _email.text, _password.text);
      if (error == null) {
        // If registration is successful, navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // If registration fails, show an error message
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Registration Failed'),


            content: Text(error),
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
  }
}

