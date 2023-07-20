import 'package:flutter/material.dart';
import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SendButton extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Function scrollListToEND;
  final Function sendMessageFCT;
  final ModelsProvider modelsProvider;
  final ChatProvider chatProvider;

  SendButton({
    required this.focusNode,
    required this.textEditingController,
    required this.scrollListToEND,
    required this.sendMessageFCT,
    required this.modelsProvider,
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
          modelsProvider: widget.modelsProvider,
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
        modelsProvider: widget.modelsProvider,
        chatProvider: widget.chatProvider,
      );
    }

    return GestureDetector(
      onLongPress: _startListening,
      onLongPressEnd: (details) => _stopListening(),
      child: IconButton(
        onPressed: sendMessageWrapper,
        icon: const Icon(
          Icons.send,
          size: 30.0,
          color: Colors.green,
        ),
      ),
    );
  }
}