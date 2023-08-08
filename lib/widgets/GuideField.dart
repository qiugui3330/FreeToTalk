import 'package:flutter/material.dart';

class GuideField extends StatelessWidget {
  final double placeholderHeightFactor; // 用于控制占位区的高度

  GuideField({this.placeholderHeightFactor = 0.35}); // 默认占位区高度为GuideField的50%

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.125, // 设置明确的高度
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFf4f3f6),
        border: Border.all(color: Colors.black87, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // 占位区
          Expanded(
            flex: (placeholderHeightFactor * 10).toInt(),
            child: Container(
              color: Color(0xFFf4f3f6), // 为了可见性，我为占位区添加了一个颜色，您可以根据需要进行修改
            ),
          ),
          // 文本显示区
          Expanded(
            flex: (10 - (placeholderHeightFactor * 10)).toInt(),
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueGrey,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      'Your guide content here',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
