import 'package:flutter/material.dart';
import 'package:chatgpt_course/services/authentication_service.dart';
import 'package:chatgpt_course/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/widgets/CustomTextField.dart';

// Defining a stateful widget for the registration page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

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
                    // Creating custom text fields for username, email, password, and confirm password
                    CustomTextField(
                      controller: _username,
                      labelText: 'Username',
                      hintText: 'Please enter username',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _email,
                      labelText: 'Email',
                      hintText: 'Please enter email',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _password,
                      labelText: 'Password',
                      hintText: 'Please enter password',
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _confirmPassword,
                      labelText: 'Confirm Password',
                      hintText: 'Please confirm password',
                      obscureText: true,
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
      var success = await authService.register(_username.text, _email.text, _password.text);
      if (success != null) {
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
            content: Text('The email is already in use'),
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