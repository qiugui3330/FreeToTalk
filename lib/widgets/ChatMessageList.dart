// 引入需要用到的包
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import 'ChatWidget.dart';

// 创建一个无状态的组件，这个组件用于渲染一个聊天消息的列表
class ChatMessageList extends StatelessWidget {
  // 聊天列表的数据
  final List<ChatModel> chatList;
  // 列表滚动控制器，用于控制列表的滚动
  final ScrollController listScrollController;

  // 使用构造函数，接收 chatList 和 listScrollController 作为参数，这两个参数都是必须的
  const ChatMessageList({
    Key? key,
    required this.chatList,
    required this.listScrollController,
  }) : super(key: key);

  // 定义 build 方法，这是每个 Flutter 组件都必须实现的方法，它用于描述如何构建当前组件
  @override
  Widget build(BuildContext context) {
    // 创建并返回一个 ListView.builder 组件，它能够根据给定的数据列表动态生成列表项
    return ListView.builder(
      // 绑定滚动控制器
      controller: listScrollController,
      // 定义列表项的数量，即 chatList 的长度
      itemCount: chatList.length,
      // 定义如何构建每一个列表项。对于每一个聊天消息，都创建并返回一个 ChatWidget 组件
      itemBuilder: (context, index) {
        return ChatWidget(
          // 将聊天消息的内容传给 ChatWidget
          msg: chatList[index].msg,
          // 将聊天消息的索引传给 ChatWidget
          chatIndex: chatList[index].chatIndex,
          // 如果当前消息是最后一条消息，则激活动画效果
          shouldAnimate: chatList.length - 1 == index,
        );
      },
    );
  }
}
