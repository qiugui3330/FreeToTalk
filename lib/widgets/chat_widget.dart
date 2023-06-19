import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
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
                        chatIndex == 0
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
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : shouldAnimate
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                                child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    repeatForever: false,
                                    displayFullTextOnTap: true,
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        msg.trim(),
                                      ),
                                    ]),
                              ),
                            )
                          : Text(
                              msg.trim(),
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              LineAwesomeIcons.thumbs_up,
                              color: Colors.black87,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              LineAwesomeIcons.thumbs_down,
                              color: Colors.black87,
                            )
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
