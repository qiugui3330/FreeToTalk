import 'dart:convert';

class Conversation {
  final int userId;
  final int type;
  final String date;
  final List<String>? parameters;

  Conversation({
    required this.userId,
    required this.type,
    required this.date,
    this.parameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'date': date,
      'parameters': parameters == null ? null : jsonEncode(parameters),
    };
  }

  static Conversation fromMap(Map<String, dynamic> map) {
    return Conversation(
      userId: map['userId'],
      type: map['type'],
      date: map['date'],
      parameters: map['parameters'] == null ? null : jsonDecode(map['parameters']),
    );
  }
}
