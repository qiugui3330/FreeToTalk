import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/providers/auth_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../constants/theme_constants.dart';
import '../../widgets/CustomTextField.dart'; // 引入自定义的文本框
import '../../widgets/CustomElevatedButton.dart'; // 引入自定义的按钮

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
                    name: 'username',
                    labelText: 'Username',
                    hintText: 'Please enter username',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(5),
                      FormBuilderValidators.maxLength(15),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'email',
                    labelText: 'Email',
                    hintText: 'Please enter email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'password',
                    labelText: 'Password',
                    hintText: 'Please enter password',
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                    ]),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    name: 'confirmPassword',
                    labelText: 'Confirm Password',
                    hintText: 'Please confirm password',
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                          (val) {
                        if (val != _formKey.currentState?.fields['password']?.value) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ]),
                  ),
                  SizedBox(height: 30),
                  CustomElevatedButton(
                    text: 'Register',
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Provider.of<AuthProvider>(context, listen: false).registerAndNavigate(
        _formKey.currentState?.fields['username']?.value,
        _formKey.currentState?.fields['email']?.value,
        _formKey.currentState?.fields['password']?.value,
        context,
      );
    }
  }
}
