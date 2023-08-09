import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/messages_provider.dart'; // 确保这是正确的导入路径

class AdviceField extends StatefulWidget {
  final double placeholderHeightFactor;

  AdviceField({Key? key, this.placeholderHeightFactor = 0.35}) : super(key: key);

  @override
  AdviceFieldState createState() => AdviceFieldState();
}

class AdviceFieldState extends State<AdviceField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, chatProvider, _) => Container(
        height: MediaQuery.of(context).size.height * 0.125,
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
              flex: (widget.placeholderHeightFactor * 10).toInt(),
              child: Container(
                color: Color(0xFFf4f3f6),
              ),
            ),
            // 文本显示区
            Expanded(
              flex: (10 - (widget.placeholderHeightFactor * 10)).toInt(),
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
                        chatProvider.getTranslation, // 这里我们直接从MessageProvider获取翻译
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
      ),
    );
  }
  void resetAdvice() {
    context.read<MessageProvider>().setTranslation('Free to ask!');
  }
}
