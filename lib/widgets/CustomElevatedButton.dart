import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomElevatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: authButtonColor,
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 20, color: primaryButtonTextColor)),
      onPressed: onPressed,
    );
  }
}
