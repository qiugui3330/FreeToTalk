import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/screens/auth/register_screen.dart';
import '../../constants/constants.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).context = context;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: appBarIconTheme,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FreeToTalk',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 40),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      labelStyle: TextStyle(color: Colors.black87),
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      labelStyle: TextStyle(color: Colors.black87),
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2E7D32),
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        // 获取表单值
                        var email = _formKey.currentState!.fields['email']!.value;
                        var password = _formKey.currentState!.fields['password']!.value;

                        try {
                          await Provider.of<AuthProvider>(context, listen: false).login(
                            email,
                            password,
                          );
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
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        color: Colors.grey[800],
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
        ),
      ),
    );
  }
}
