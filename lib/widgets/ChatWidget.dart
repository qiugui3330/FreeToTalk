import 'package:chatgpt_course/widgets/WordSelectionDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:provider/provider.dart';

import '../providers/chats_provider.dart';
import 'TextWidget.dart';

class ChatWidget extends StatefulWidget {
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

class _ChatWidgetState extends State<ChatWidget> {
  bool _isTextVisible = false;
  late final FlutterTts _flutterTts;
  String? _selectedWord;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    if (widget.chatIndex != 0) {
      _playTtsAudio(widget.msg);
    }
  }

  Future _playTtsAudio(String message) => _flutterTts.speak(message);

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


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (widget.chatIndex == 0)
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  await _playTtsAudio(widget.msg);
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
                        await _playTtsAudio(widget.msg);
                      },
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
