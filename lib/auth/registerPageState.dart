import 'package:chatgpt_course/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/authentication_service.dart';
import '../widgets/CustomTextField.dart';
import 'login_page.dart';

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
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
                    CustomTextField(
                      controller: _username,
                      labelText: 'Username',
                      hintText: 'Please enter username',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        if (value.length < 5 || value.length > 15) {
                          return 'Username should be between 5 and 15 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _email,
                      labelText: 'Email',
                      hintText: 'Please enter email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!value.contains(RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}'))) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _password,
                      labelText: 'Password',
                      hintText: 'Please enter password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 8 || !value.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'))) {
                          return 'Password must be at least 8 characters long and include uppercase, lowercase, number, and special character';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _confirmPassword,
                      labelText: 'Confirm Password',
                      hintText: 'Please confirm password',
                      obscureText: true,
                      validator: (value) {
                        if (value != _password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Register'),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? registerResult = await Provider.of<AuthProvider>(context, listen: false).register(
        _username.text,
        _email.text,
        _password.text,
      );

      if (registerResult == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        _showErrorDialog(registerResult);
      }
    }
  }

  void _showErrorDialog(String message) {
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
