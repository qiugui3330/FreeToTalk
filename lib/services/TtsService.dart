import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  late final FlutterTts _flutterTts;

  TtsService() {
    _flutterTts = FlutterTts();
  }

  Future speak(String message) => _flutterTts.speak(message);
}