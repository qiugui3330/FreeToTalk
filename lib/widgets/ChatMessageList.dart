import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import 'ChatWidget.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatModel> chatList;
  final ScrollController listScrollController;

  const ChatMessageList({
    Key? key,
    required this.chatList,
    required this.listScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: listScrollController,
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return ChatWidget(
          msg: chatList[index].msg,
          chatIndex: chatList[index].chatIndex,
          shouldAnimate: chatList.length - 1 == index,
        );
      },
    );
  }
}