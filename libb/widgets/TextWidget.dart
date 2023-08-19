import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import '../database/models/user_model.dart';

class TextWidget extends StatelessWidget {

  const TextWidget(
      {Key? key,
        required this.label,
        this.fontSize = 14,
        this.color,
        this.fontWeight,
        this.user})
      : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final User? user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user?.username ?? 'User',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: textBlackColor),),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightGreyColor,
              border: Border.all(
                color: blackBorderColor,
                width: 1.5
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50.0),
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            child: Text(
              label,
   
              style: TextStyle(
                color: color ?? textBlackColor,
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
