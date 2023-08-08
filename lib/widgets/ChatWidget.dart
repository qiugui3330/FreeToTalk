// 导入必要的包和模块
import 'package:chatgpt_course/widgets/WordSelectionDialog.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:chatgpt_course/services/TtsService.dart'; // 导入 TtsService
import 'TextWidget.dart';

// 定义一个名为 ChatWidget 的有状态的 widget
class ChatWidget extends StatefulWidget {
  // 构造函数，用于初始化 ChatWidget 的实例
  const ChatWidget({
    super.key,
    required this.msg,
    required this.chatIndex,
    this.shouldAnimate = false,
  });

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

// ChatWidget 的状态类
class _ChatWidgetState extends State<ChatWidget> {
  // 定义和初始化状态变量
  bool _isTextVisible = false;
  final TtsService _ttsService = TtsService(); // 在这里初始化 TtsService
  String? _selectedWord;

  // initState 是一个特殊的函数，在 widget 生命周期中，当 widget 创建并插入到 widget 树中时，该函数会被调用
  @override
  void initState() {
    super.initState();
    if (widget.chatIndex != 0) {
      _ttsService.speak(widget.msg); // 使用 TtsService 的 speak 方法
    }
  }

  // _showWordSelectionDialog 方法用于显示单词选择对话框
  void _showWordSelectionDialog(String msg) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Label",
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return WordSelectionDialog(msg: msg, parentContext: context);
          },
        );
      },
    );
  }

  // build 方法用于构建 widget 的 UI
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 保持头像和按钮靠上
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10, left: 20),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 72, 69, 69).withOpacity(0.3),
                        blurRadius: 1.0,
                        spreadRadius: 2.0),
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      widget.chatIndex == 0 ? AssetsManager.userImage : AssetsManager.botImage,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                  onLongPress: () {
                    _showWordSelectionDialog(widget.msg);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0), // 使文本垂直居中
                    child: widget.chatIndex == 0
                        ? TextWidget(
                      label: widget.msg,
                    )
                        : _isTextVisible
                        ? Text(
                      widget.msg.trim(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    )
                        : Text(
                      "Text is hidden",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              if (widget.chatIndex == 0)
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () async {
                    await _ttsService.speak(widget.msg); // 使用 TtsService 的 speak 方法
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        color: Colors.black87,
                        onPressed: () {
                          setState(() {
                            _isTextVisible = !_isTextVisible;
                          });
                        },
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () async {
                          await _ttsService.speak(widget.msg); // 使用 TtsService 的 speak 方法
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }



}
