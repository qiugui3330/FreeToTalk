import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/screens/auth/register_screen.dart';
import '../../constants/theme_constants.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/CustomElevatedButton.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).context = context;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryAppBarColor,
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
                      color: primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    name: 'email',
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'password',
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                  SizedBox(height: 30),
                  CustomElevatedButton(
                    text: 'Login',
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
                        color: tertiaryTextColor,
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
