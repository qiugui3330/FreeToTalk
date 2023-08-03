import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_course/constants/api_consts.dart';
import 'package:chatgpt_course/models/chat_model.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static Future<List<ChatModel>> chatWithModel(
      {required String message}) async {
    try {
      log("Sending message: $message");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": MODEL_NAME,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) {
            String msg = jsonResponse["choices"][index]["message"]["content"];
            log("Received message: $msg");
            return ChatModel(msg: msg, chatIndex: 1);
          },
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static Future<List<ChatModel>> generateCompletion(
      {required String message, required String modelId}) async {
    try {
      log("Sending message: $message");
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": MODEL_NAME,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) {
            String msg = jsonResponse["choices"][index]["text"];
            log("Received message: $msg");
            return ChatModel(msg: msg, chatIndex: 1);
          },
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static Future<String> getTranslation(
      {required String word, required String fullSentence}) async {
    try {
      String prompt = "\"$word\" 在 \"$fullSentence\" 中是什么意思？请用中文回答，只给出 \"$word\" 在这句中表达的意思。";

      print('Question: $prompt');

      var response = await http.post(
        Uri.parse("$BASE_URL/completions"), // change the endpoint to /completions
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": MODEL_NAME, // or your preferred model
            "prompt": prompt,
            "max_tokens": 600
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse["choices"].length > 0) {
        String answer = jsonResponse["choices"][0]["text"].trim();

        // Print the answer to the console
        print('Answer: $answer');

        return answer; // return the translation
      }

      return '';
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}

