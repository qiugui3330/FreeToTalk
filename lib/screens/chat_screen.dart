import 'dart:developer';

import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/TextWidget.dart';
import '/widgets/ChatMessageList.dart';
import '/widgets/MessageInputField.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(LineAwesomeIcons.bars, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AssetsManager.openaiLogo),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FreeToTalk',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'GPT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () async {
              // await Services.showModalSheet(context: context);
            },
            icon: Icon(
              LineAwesomeIcons.vertical_ellipsis,
              size: 30,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      drawer: CustomDrawer(user: widget.user),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ChatMessageList(
                chatList: chatProvider.getChatList,
                listScrollController: _listScrollController,
              ),
            ),
            if (_isTyping)
              ...[
                const SpinKitThreeBounce(
                  color: Colors.black87,
                  size: 18,
                ),
              ],
            const SizedBox(
              height: 15,
            ),
            MessageInputField(
              focusNode: focusNode,
              textEditingController: textEditingController,
              onSubmitted: (String value) {
                sendMessageFCT(
                  modelsProvider: modelsProvider,
                  chatProvider: chatProvider,
                );
                scrollListToEND();
              },
              modelsProvider: modelsProvider,
              chatProvider: chatProvider,
              scrollListToEND: scrollListToEND,
              sendMessageFCT: sendMessageFCT,
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
        required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);

      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}