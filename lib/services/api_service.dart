import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:chatgpt_course/constants/api_consts.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const int TOKEN_LIMIT = 4096;  

  static Future<Map<String, dynamic>> sendPostRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      String? contentToSend;
      if (body.containsKey("messages")) {
        contentToSend = body["messages"][0]["content"];
      } else if (body.containsKey('prompt')) {
        contentToSend = body["prompt"];
      }

      if (contentToSend != null) {
        if (contentToSend.length > TOKEN_LIMIT) {
          throw Exception('Content exceeds token limit.');
        }
        printLongString('Sending to GPT: $contentToSend');
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load AI response. HTTP status code: ${response.statusCode}');
      }

      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));

  
      String? gptResponse = decodedResponse["choices"]?.first?["text"];
      if (gptResponse != null) {
        printLongString('GPT Response: ${gptResponse.trim()}');
      }

      return decodedResponse;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static Future<List<String>> postChatMessageToModel({required String message}) async {
    Map<String, dynamic> body = {
      "model": MESSAGE_MODEL_NAME,
      "messages": [
        {
          "role": "user",
          "content": message,
        }
      ]
    };

    Map<String, dynamic> response = await sendPostRequest(
        url: "$BASE_URL/chat/completions", body: body);
    return processResponse(response);
  }

  static Future<List<String>> generateTextCompletion({required String message}) async {
    Map<String, dynamic> body = {
      'prompt': message,
      'max_tokens': 60,
    };
    Map<String, dynamic> response = await sendPostRequest(
        url: '$BASE_URL/engines/$MESSAGE_MODEL_NAME/completions', body: body);
    return processCompletionResponse(response);
  }

  static Future<String> generatePrompt({required String prompt}) async {
    Map<String, dynamic> body = {
      "model": PROMPT_MODEL_NAME,
      "prompt": prompt,
      "max_tokens": 600
    };

    Map<String, dynamic> response = await sendPostRequest(
        url: "$BASE_URL/completions", body: body);
    return processPromptResponse(response);
  }

  static List<String> processResponse(Map<String, dynamic> response) {
    if (response['error'] != null) {
      throw Exception(response['error']["message"]);
    }
    List<String> results = [];
    if (response.containsKey("choices") && response["choices"].length > 0) {
      results = response["choices"]
          .map((choice) => choice["message"]["content"])
          .toList()
          .cast<String>();
    } else if (response.containsKey('text')) {
      results.add(response['text'].trim());
    }
    return results;
  }

  static List<String> processCompletionResponse(Map<String, dynamic> response) {
    if (response['error'] != null) {
      throw Exception(response['error']["message"]);
    }
    List<String> responses = [];
    if (response.containsKey('choices') && response['choices'].length > 0) {
      responses.add(response['choices'][0]['text'].trim());
    } else {
      throw Exception('No choice found in the AI response');
    }
    return responses;
  }

  static String processPromptResponse(Map<String, dynamic> response) {
    if (response['error'] != null) {
      throw Exception(response['error']["message"]);
    }
    if (response["choices"].length > 0) {
      return response["choices"][0]["text"].trim();
    }
    return '';
  }

  static void printLongString(String longString){
    const int maxLength = 500;  
    int startIndex = 0;
    int endIndex = 0;

    while (startIndex < longString.length) {
      endIndex = math.min(startIndex + maxLength, longString.length);
      print(longString.substring(startIndex, endIndex));
      startIndex = endIndex;
    }
  }
}