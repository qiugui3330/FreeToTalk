import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;  // Make it nullable

  CustomTextField({
    required this.name,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.controller,  // Remove the 'required' keyword
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,  // This will be null if not provided
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
