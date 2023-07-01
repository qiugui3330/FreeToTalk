import 'package:flutter/material.dart';
import 'package:chatgpt_course/services/authentication_service.dart';
import 'package:chatgpt_course/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/widgets/CustomTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

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
        title: Text("Register"),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var authService = Provider.of<AuthenticationService>(context, listen: false);
      var success = await authService.register(_username.text, _email.text, _password.text);
      if (success != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
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