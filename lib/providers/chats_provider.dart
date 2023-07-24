import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  String translation = '';

  String get getTranslation => translation;

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }

  Future<void> getTranslationAndDisplay(String word, String fullSentence) async {
    translation = 'Querying...'; // set to "Querying..." before the query
    notifyListeners();
    translation = await ApiService.getTranslation(word: word, fullSentence: fullSentence);
    notifyListeners();
  }

  void setTranslation(String s) {
    translation = s;
    notifyListeners();
  }
}
