import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_service.dart';
import '../services/TtsService.dart';

class WordBookPage extends StatefulWidget {
  @override
  _WordBookPageState createState() => _WordBookPageState();
}

class _WordBookPageState extends State<WordBookPage> {
  late Future<List<Map<String, dynamic>>> _wordsFuture;
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _wordsFuture = DatabaseService.instance.getAllWordsSortedByDate();
  }

  Map<String, List<Map<String, dynamic>>> groupByDate(List<Map<String, dynamic>> words) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var word in words) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(word['addDate']));
      if (!grouped.containsKey(formattedDate)) {
        grouped[formattedDate] = [];
      }
      grouped[formattedDate]!.add(word);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Word Book',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(244, 243, 246, 1),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final groupedWords = groupByDate(snapshot.data!);
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: groupedWords.entries.map((entry) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double cardWidth = screenWidth - 16.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          entry.key,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      ...entry.value.map((word) {
                        return Container(
                          width: cardWidth,
                          child: Card(
                            color: Colors.grey[200],
                            margin: EdgeInsets.only(bottom: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (word['word'] != null)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(word['word']!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                                        IconButton(
                                          icon: Icon(Icons.play_arrow, color: Colors.grey[400]),
                                          onPressed: () => _ttsService.speak(word['word']!),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 3.0),
                                  if (word['translation'] != null)
                                    Text(word['translation']!, style: TextStyle(fontSize: 16, color: Colors.black)),
                                  SizedBox(height: 3.0),
                                  if (word['originalSentence'] != null)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(word['originalSentence']!, style: TextStyle(fontSize: 16, color: Colors.black)),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.play_arrow, color: Colors.grey[400]),
                                          onPressed: () => _ttsService.speak(word['originalSentence']!),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text('No words found.', style: TextStyle(color: Colors.black)));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}
