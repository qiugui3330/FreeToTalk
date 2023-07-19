// Importing necessary libraries and modules
import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

// Defining a ChatProvider class that extends ChangeNotifier
class ChatProvider with ChangeNotifier {
  // Defining a list to store chat messages
  List<ChatModel> chatList = [];

  // Defining a getter to get the chat list
  List<ChatModel> get getChatList {
    return chatList;
  }

  // Defining a method to add a user message to the chat list
  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  // Defining a method to send a message and get answers
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
}
