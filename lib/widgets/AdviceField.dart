import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/messages_provider.dart';

class AdviceField extends StatefulWidget {
  final double placeholderHeightFactor;

  AdviceField({this.placeholderHeightFactor = 0.35});

  @override
  _AdviceFieldState createState() => _AdviceFieldState();
}

class _AdviceFieldState extends State<AdviceField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFf4f3f6),
        border: Border.all(color: Colors.black87, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          Expanded(
            flex: (widget.placeholderHeightFactor * 10).toInt(),
            child: Container(
              color: Color(0xFFf4f3f6),
            ),
          ),
          Expanded(
            flex: (10 - (widget.placeholderHeightFactor * 10)).toInt(),
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueGrey,
              ),
              child: Consumer<MessageProvider>(
                builder: (context, messageProvider, _) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        messageProvider.getTranslation,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}