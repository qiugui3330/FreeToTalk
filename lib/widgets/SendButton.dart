import 'package:flutter/material.dart';
import 'package:chatgpt_course/providers/messages_provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../constants/theme_constants.dart';

class SendButton extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Function scrollListToEND;
  final Function sendMessageFCT;
  final MessageProvider chatProvider;

  SendButton({
    required this.focusNode,
    required this.textEditingController,
    required this.scrollListToEND,
    required this.sendMessageFCT,
    required this.chatProvider,
  });

  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  stt.SpeechToText _speech = stt.SpeechToText();
  String _speechText = '';

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    await _speech.initialize();
  }

  void _startListening() async {
    if (_speech.isAvailable && !_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _speechText = result.recognizedWords;
          });
        },
        localeId: 'en_US',
      );
    }
  }

  void _stopListening() async {
    if (_speech.isAvailable && _speech.isListening) {
      await _speech.stop();
      if (_speechText.isNotEmpty) {
        widget.textEditingController.text = _speechText;
        widget.sendMessageFCT(
          chatProvider: widget.chatProvider,
        );
        _speechText = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void sendMessageWrapper() {
      widget.sendMessageFCT(
        chatProvider: widget.chatProvider,
      );
    }

    return GestureDetector(
      onLongPress: _startListening,
      onLongPressEnd: (details) => _stopListening(),
      child: Container(
        padding: EdgeInsets.all(5),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 64, 63, 63),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
          color: whiteColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: IconButton(
                onPressed: sendMessageWrapper,
                icon: const Icon(
                  LineAwesomeIcons.telegram_plane,
                  color: iconYellowColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
