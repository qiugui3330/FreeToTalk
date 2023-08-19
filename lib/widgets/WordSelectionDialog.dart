import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_course/services/TtsService.dart';
import 'dart:math';

import '../database/database_service.dart';
import '../database/models/word_model.dart';
import '../providers/messages_provider.dart';

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
  late MessageProvider provider;
  late TtsService _ttsService;
  Timer? _timer;
  String? _lastTranslationQuery;
  String? _lastFullQuery;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    provider = Provider.of<MessageProvider>(context, listen: false);
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

    List<String> selectedStrings = [];
    for (int i = 0; i < _selectedWords.length; i++) {
      selectedStrings.add(words[_selectedWords[i]]);
      if (i != _selectedWords.length - 1) {
        selectedStrings
            .add(_selectedWords[i + 1] - _selectedWords[i] == 1 ? ' ' : '...');
      }
    }

    String translationQuery = selectedStrings.join('');

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

    _lastTranslationQuery = translationQuery;
    _lastFullQuery = fullQuery;

    provider.getTranslationResult(translationQuery, fullQuery);
  }

  void _toggleWordSelection(int index, List<String> words) {
    setState(() {
      if (_multiSelectStartIndex != null) {
        int start = min(_multiSelectStartIndex!, index);
        int end = max(_multiSelectStartIndex!, index);
        _selectedWords = List<int>.generate(end - start + 1, (i) => start + i);
        _multiSelectStartIndex = null;
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
        provider.setTranslation('');
      }
    });
  }

  void _toggleSelectAllWords(List<String> words) {
    setState(() {
      if (_selectedWords.length == words.length) {
        _selectedWords = [];
        provider.setTranslation('');
      } else {
        _selectedWords = List<int>.generate(words.length, (i) => i);
        provider.setTranslation('Waiting...');
        _timer?.cancel();
        _timer = Timer(Duration(seconds: 2), () {
          _selectWords(words);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(r"\b\w+\'\w+\b|\w+|[^\w\s\'\n]|\s+");
    List<String> words =
        exp.allMatches(widget.msg).map((m) => m.group(0)!).toList();
    words.removeWhere((word) => word.trim() == '' || word.contains('\n'));

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: MediaQuery.of(widget.parentContext).size.width * 0.9,
          height: MediaQuery.of(widget.parentContext).size.height / 2.3,
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
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Consumer<MessageProvider>(
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
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () async {
                                    if (provider.getTranslation ==
                                        'Waiting...') {
   
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please wait for the translation'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_lastTranslationQuery != null &&
                                        _lastFullQuery != null) {
                                      Word word = Word(
                                        word: _lastTranslationQuery!,
                                        translation: provider.getTranslation,
                                        addDate: DateTime.now(),
                                        originalSentence: _lastFullQuery!,
                                      );

                                      try {
                                        await DatabaseService.instance
                                            .insertWord(word
                                                .toMap());
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Icon(Icons.add, size: 20),
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {
                                    String wordsToSpeak = _selectedWords
                                        .map((index) => words[index])
                                        .join(' ');
                                    _ttsService.speak(wordsToSpeak);
                                  },
                                  child: Icon(Icons.play_arrow, size: 20),
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () => _toggleSelectAllWords(words),
                                  child: Icon(Icons.select_all, size: 20),
                                ),
                                FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {
                                    if (_lastTranslationQuery != null &&
                                        _lastFullQuery != null) {
                                      provider.getTranslationResult(
                                          _lastTranslationQuery!,
                                          _lastFullQuery!);
                                    }
                                  },
                                  child: Icon(Icons.refresh, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
