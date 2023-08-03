import 'package:flutter/cupertino.dart';

import '../database/conversation_model.dart';

class ConversationProvider with ChangeNotifier {
  Conversation? _currentConversation;

  void setCurrentConversation(Conversation conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }

  Conversation? getCurrentConversation() {
    return _currentConversation;
  }

  String? getCurrentModelName() {
    if (_currentConversation == null) return null;
    switch (_currentConversation!.type) {
      case 1:
        return "Free Talk";
      case 2:
        return "Roleplay Dialogue";
      case 3:
        return "Review Prompts";
      default:
        return null;
    }
  }

  void clearCurrentConversation() {
    _currentConversation = null;
    notifyListeners();
  }
}
