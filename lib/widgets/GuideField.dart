import 'package:flutter/material.dart';

class GuideField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFf4f3f6),
        border: Border.all(color: Colors.black87, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      // 这里可以添加您想要显示的内容
    );
  }
}
