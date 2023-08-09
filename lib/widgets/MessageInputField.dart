import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/constants.dart';
import '../providers/messages_provider.dart';
import 'SendButton.dart';
import 'AdviceField.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final MessageProvider chatProvider;
  final Function scrollListToEND;
  final Function sendMessageFCT;

  const MessageInputField({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.onSubmitted,
    required this.chatProvider,
    required this.scrollListToEND,
    required this.sendMessageFCT,
  }) : super(key: key);

  @override
  _MessageInputFieldState createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final adviceFieldKey = GlobalKey<AdviceFieldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: 0.5).animate(_animationController);
  }

  void _handleFlyButtonPress({bool resetText = false}) {
    if (_animationController.isCompleted) {
      _animationController.reverse();
      adviceFieldKey.currentState!.resetAdvice();
      if (resetText) {
        widget.textEditingController.text = "Free to ask!";
      }
    } else {
      _animationController.forward();
      final mean = widget.textEditingController.text.isEmpty
          ? null
          : widget.textEditingController.text;
      final sentence = widget.chatProvider.getChatList.isNotEmpty
          ? widget.chatProvider.getChatList.last.msg
          : null;

      widget.chatProvider.getAdviceResult(mean, sentence).then((_) {
        widget.chatProvider.setTranslation(widget.chatProvider.getTranslation);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          _handleFlyButtonPress();
        } else if (details.delta.dy > 0) {
          _handleFlyButtonPress(resetText: true);
        }
      },
      child: Stack(
        children: [
          AdviceField(key: adviceFieldKey),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0,
                    -_animation.value *
                        MediaQuery.of(context).size.height *
                        0.16),
                child: child,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFf4f3f6),
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(LineAwesomeIcons.fly),
                        onPressed: _handleFlyButtonPress,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          focusNode: widget.focusNode,
                          style: const TextStyle(color: Colors.black87),
                          controller: widget.textEditingController,
                          onSubmitted: widget.onSubmitted,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Let's go!",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 97, 97, 97),
                            ),
                          ),
                        ),
                      ),
                      SendButton(
                        focusNode: widget.focusNode,
                        textEditingController: widget.textEditingController,
                        scrollListToEND: widget.scrollListToEND,
                        sendMessageFCT: widget.sendMessageFCT,
                        chatProvider: widget.chatProvider,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}