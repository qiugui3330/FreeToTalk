import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';

import 'TextWidget.dart';

import 'package:flutter_tts/flutter_tts.dart';


class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {super.key,
        required this.msg,
        required this.chatIndex,
        this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool _isTextVisible = false; // Set initial value to false
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    // If it's a bot message, play the TTS audio automatically
    if (widget.chatIndex != 0) {
      _playTtsAudio(widget.msg);
    }
  }

  Future<void> _playTtsAudio(String message) async {
    await _flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 20, left: 20),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color:
                          Color.fromARGB(255, 72, 69, 69).withOpacity(0.3),
                          blurRadius: 1.0,
                          spreadRadius: 2.0),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        widget.chatIndex == 0
                            ? AssetsManager.userImage
                            : AssetsManager.botImage,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
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
                if (widget.chatIndex == 0)
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () async {
                      // Playing the audio
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
                            // Toggling text visibility
                            setState(() {
                              _isTextVisible = !_isTextVisible;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () async {
                            // Playing the audio
                            await _playTtsAudio(widget.msg);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}