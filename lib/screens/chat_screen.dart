import 'dart:developer';

import 'package:chatgpt_course/database/models/user_model.dart';
import 'package:chatgpt_course/providers/conversation_provider.dart';
import 'package:chatgpt_course/providers/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/theme_constants.dart';
import '/widgets/ChatMessageList.dart';
import '/widgets/MessageInputField.dart';
import '../services/assets_manager.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/TextWidget.dart';

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
    final chatProvider = Provider.of<MessageProvider>(context);
    final conversationProvider = Provider.of<ConversationProvider>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: primaryAppBarColor,
          iconTheme: appBarIconTheme,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(LineAwesomeIcons.bars, color: primaryIconColor),
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
                  border: Border.all(color: primaryBorderColor, width: 1),
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
                      style: TextStyle(color: primaryTextColor),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Consumer<ConversationProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.getCurrentModelName() ?? 'Default mode',
                          style: TextStyle(
                            fontSize: 12,
                            color: greenTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
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
            Consumer<ConversationProvider>(
              builder: (context, conversationProvider, child) {
                return conversationProvider.getCurrentConversation() != null
                    ? IconButton(
                        icon: Icon(Icons.exit_to_app, color: primaryIconColor),
                        onPressed: () {
                          String modelName =
                              conversationProvider.getCurrentModelName() ??
                                  "Unknown Model";
                          conversationProvider.clearCurrentConversation();
                          Provider.of<MessageProvider>(context, listen: false)
                              .clearChat();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Exited $modelName, conversation ended.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox.shrink();
              },
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
              Expanded(
                child: Stack(
                  children: [
                    ChatMessageList(
                      chatList: chatProvider.getChatList,
                      listScrollController: _listScrollController,
                    ),
                    if (_isTyping)
                      Align(
                        alignment: Alignment.topCenter,
                        child: const SpinKitThreeBounce(
                          color: spinKitColor,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MessageInputField(
                  focusNode: focusNode,
                  textEditingController: textEditingController,
                  onSubmitted: (String value) {
                    sendMessageFCT(chatProvider: chatProvider);
                    scrollListToEND();
                  },
                  chatProvider: chatProvider,
                  scrollListToEND: scrollListToEND,
                  sendMessageFCT: sendMessageFCT,
                ),
              ),
            ],
          ),
        ));
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT({required MessageProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: snackBarBackgroundColor,
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
          backgroundColor: snackBarBackgroundColor,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(msg: msg);

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: snackBarBackgroundColor,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
