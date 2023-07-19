import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/constants.dart';
import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';
import 'SendButton.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final ModelsProvider modelsProvider;
  final ChatProvider chatProvider;
  final Function scrollListToEND;
  final Function sendMessageFCT;

  const MessageInputField({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.onSubmitted,
    required this.modelsProvider,
    required this.chatProvider,
    required this.scrollListToEND,
    required this.sendMessageFCT,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onSubmitted: onSubmitted,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Let's go!",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SendButton(
                focusNode: focusNode,
                textEditingController: textEditingController,
                modelsProvider: modelsProvider,
                chatProvider: chatProvider,
                scrollListToEND: scrollListToEND,
                sendMessageFCT: sendMessageFCT,
              ),
            ],
          ),
        ),
      ),
    );
  }
}