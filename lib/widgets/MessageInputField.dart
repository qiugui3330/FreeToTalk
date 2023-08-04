import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/constants.dart';
import '../providers/messages_provider.dart';
import 'SendButton.dart';

// MessageInputField 是一个 StatelessWidget，这是一个输入框组件，
// 它包含了一些用于输入和发送信息的 UI 元素
class MessageInputField extends StatelessWidget {
  // 下面是几个传入此组件的参数
  final TextEditingController textEditingController; // 文本输入框的控制器
  final FocusNode focusNode;  // 用于管理此文本框焦点的焦点节点
  final Function(String) onSubmitted;  // 在文本提交（按下回车）时的回调函数
  final MessageProvider chatProvider;  // 聊天的消息提供器
  final Function scrollListToEND;  // 滚动聊天列表到最后的函数
  final Function sendMessageFCT;  // 发送消息的函数

  // 这是构造函数，用于初始化此组件的各个参数
  const MessageInputField({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.onSubmitted,
    required this.chatProvider,
    required this.scrollListToEND,
    required this.sendMessageFCT,
  }) : super(key: key);

  // build 方法用于构建此组件的 UI
  @override
  Widget build(BuildContext context) {
    // 返回一个包含了内边距、装饰（包括颜色、边框等）和子组件的容器组件
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20), // 外边距
      padding: EdgeInsets.all(16), // 内边距
      decoration: BoxDecoration(
        color: Colors.grey[200], // 背景色
        border: Border.all(color: Colors.black87, width: 1.5), // 边框颜色和宽度
        borderRadius: BorderRadius.all(
          Radius.circular(20.0), // 边框圆角
        ),
      ),
      child: Material(
        color: cardColor, // 子组件背景色
        child: Padding(
          padding: const EdgeInsets.all(5.0), // 子组件的内边距
          child: Row( // 横向排列子组件的 Row 组件
            children: [
              Icon(LineAwesomeIcons.smiling_face), // 表情图标
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField( // 文本输入框
                  focusNode: focusNode,
                  style: const TextStyle(color: Colors.black87),
                  controller: textEditingController,
                  onSubmitted: onSubmitted,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Let's go!", // 提示文字
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SendButton( // 发送按钮
                focusNode: focusNode,
                textEditingController: textEditingController,
                scrollListToEND: scrollListToEND,
                sendMessageFCT: sendMessageFCT,
                chatProvider: chatProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
