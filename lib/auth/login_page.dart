import 'package:flutter/material.dart';
import 'package:chatgpt_course/services/authentication_service.dart';
import 'package:flutter/services.dart';
import 'package:chatgpt_course/screens/chat_screen.dart';
import 'package:chatgpt_course/auth/register_page.dart';
import 'package:chatgpt_course/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../database/models/user_model.dart';
import '../providers/auth_provider.dart';

 
class LoginPage extends StatelessWidget {
 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 
  final authService = AuthenticationService();

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
 
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
 
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
 
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              SizedBox(height: 20),
 
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              SizedBox(height: 20),
 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Login', style: TextStyle(fontSize: 20)),
                onPressed: () async {  // 注意这里添加了 async
                  try {
                    User? user = await Provider.of<AuthProvider>(context, listen: false).login(  // 这里添加了 await
                      emailController.text,
                      passwordController.text,
                    );

                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(user: user),
                        ),
                      );
                    }
                  } catch (e) {
 
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(e.toString()),
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
 
              GestureDetector(
                child: Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
 
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
