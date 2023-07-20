import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chatgpt_course/services/assets_manager.dart';

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

  void _showWordSelectionDialog(String msg) {
    List<String> words = msg.split(RegExp(r'\b'));
    words.removeWhere((word) => word.trim() == '' || word.contains('\n')); // remove empty strings and line breaks

    showGeneralDialog(
      context: context,
      barrierLabel: "Label",
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // dialog width is 90% of screen width
              height: MediaQuery.of(context).size.height / 3, // dialog height is 33.33% of screen height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0), // Adjust padding as needed
              child: SingleChildScrollView( // enable scrolling
                scrollDirection: Axis.vertical,
                child: Wrap(
                  alignment: WrapAlignment.start, // Left alignment
                  spacing: 0, // no spacing between buttons
                  runSpacing: 3.0, // gap between rows
                  children: words.map((word) =>
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0), // adjust as needed
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 244, 243, 246), // Set color here
                            minimumSize: Size(30, 30), // adjust as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // rounded rectangle
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // adjust as needed
                          ),
                          onPressed: () {
                            // handle button click event
                          },
                          child: Text(
                            word,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      )
                  ).toList(),
                ),
              ),
            ),
          ),
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
    );
  }
}
