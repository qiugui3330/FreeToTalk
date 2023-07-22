import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/chats_provider.dart';

class WordSelectionDialog extends StatefulWidget {
  final String msg;
  final BuildContext parentContext;

  WordSelectionDialog({required this.msg, required this.parentContext});

  @override
  _WordSelectionDialogState createState() => _WordSelectionDialogState();
}

class _WordSelectionDialogState extends State<WordSelectionDialog> {
  List<int> _selectedWords = [];
  int? _multiSelectStartIndex;
  late ChatProvider provider;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      provider.setTranslation('');
    });
  }

  void _onLongPress(int index) {
    HapticFeedback.vibrate();
    setState(() {
      _multiSelectStartIndex = index;
      _selectedWords = [index];
    });
    provider.setTranslation('Waiting...');
  }

  void _selectWords(List<String> words) {
    _selectedWords.sort();

    // Create selectedStrings by adding words and '...' or ' ' appropriately
    List<String> selectedStrings = [];
    for (int i = 0; i < _selectedWords.length; i++) {
      selectedStrings.add(words[_selectedWords[i]]);
      if (i != _selectedWords.length - 1) {
        selectedStrings.add(_selectedWords[i + 1] - _selectedWords[i] == 1 ? ' ' : '...');
      }
    }
    String translationQuery = selectedStrings.join('');

    // Create a copy of _selectedWords to not modify the original
    List<int> tempSelectedWords = List.from(_selectedWords);

    while (tempSelectedWords.first > 0 &&
        !words[tempSelectedWords.first - 1].contains(RegExp(r'[.,;?!。，；？！]'))) {
      tempSelectedWords.insert(0, tempSelectedWords.first - 1);
    }

    while (tempSelectedWords.last < words.length - 1 &&
        !words[tempSelectedWords.last + 1].contains(RegExp(r'[.,;?!。，；？！]'))) {
      tempSelectedWords.add(tempSelectedWords.last + 1);
    }

    String fullQuery = tempSelectedWords.map((index) => words[index]).join(' ');

    provider.getTranslationAndDisplay(translationQuery, fullQuery);
  }

  void _toggleWordSelection(int index, List<String> words) {
    setState(() {
      if (_multiSelectStartIndex != null) {
        // In multi-select mode
        int start = min(_multiSelectStartIndex!, index);
        int end = max(_multiSelectStartIndex!, index);
        _selectedWords = List<int>.generate(end - start + 1, (i) => start + i);
        _multiSelectStartIndex = null; // Exit multi-select mode
      } else {
        if (_selectedWords.contains(index)) {
          _selectedWords.remove(index);
        } else {
          _selectedWords.add(index);
        }
      }
    });
    provider.setTranslation('Waiting...');
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 2), () {
      if (_selectedWords.isNotEmpty) {
        _selectWords(words);
      } else {
        provider
            .setTranslation(''); // No words selected, clear translation area
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.msg.split(RegExp(r'\b'));
    words.removeWhere((word) => word.trim() == '' || word.contains('\n'));

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: MediaQuery.of(widget.parentContext).size.width * 0.9,
          height: MediaQuery.of(widget.parentContext).size.height / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 0,
                    runSpacing: 3.0,
                    children: words
                        .asMap()
                        .entries
                        .map((entry) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: _selectedWords.contains(entry.key)
                                      ? _multiSelectStartIndex != null &&
                                              _selectedWords.first == entry.key
                                          ? Colors.green
                                          : Colors.blue
                                      : Color.fromARGB(255, 244, 243, 246),
                                  minimumSize: Size(30, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                ),
                                onPressed: () =>
                                    _toggleWordSelection(entry.key, words),
                                onLongPress: () => _onLongPress(entry.key),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueGrey,
                  ),
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, _) =>
                        SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            chatProvider.getTranslation,
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
        ),
      ),
    );
  }
}
