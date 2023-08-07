class Message {
  final int conversationId;
  final String content;
  final bool isUserMessage;

  Message({
    required this.conversationId,
    required this.content,
    required this.isUserMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'content': content,
      'isUserMessage': isUserMessage ? 1 : 0,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      conversationId: map['conversationId'],
      content: map['content'],
      isUserMessage: map['isUserMessage'] == 1,
    );
  }
}
