// Defining a ChatModel class
class ChatModel {
  // Defining properties for the class
  final String msg;
  final int chatIndex;

  // Defining a constructor for the class
  ChatModel({required this.msg, required this.chatIndex});

  // Defining a factory method to create an instance of the class from a JSON object
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    msg: json["msg"],
    chatIndex: json["chatIndex"],
  );
}
