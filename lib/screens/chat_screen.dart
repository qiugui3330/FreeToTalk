import 'dart:developer';

import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/services/services.dart';
import 'package:chatgpt_course/services/user_model.dart';
import 'package:chatgpt_course/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.user.username,
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                widget.user.email, // Change this line with your variable
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(AssetsManager.openaiLogo), // Change this line with your variable
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 243, 246, 1),
              ),
            ),
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                // Put your onTap function here
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                // Put your onTap function here
              },
            ),
            ListTile(
              title: Text('To Be Determined'),
              onTap: () {
                // Put your onTap function here
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    shouldAnimate: chatProvider.getChatList.length - 1 == index,
                  );
                },
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Icon(LineAwesomeIcons.smiling_face),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.black87),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider,
                            );
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: "Let's go!",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () async {
                                  await sendMessageFCT(
                                    modelsProvider: modelsProvider,
                                    chatProvider: chatProvider,
                                  );
                                },
                                icon: const Icon(
                                  LineAwesomeIcons.telegram_plane,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
