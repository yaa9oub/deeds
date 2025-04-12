import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../core/utils/env.dart';

class ChatRemoteDataSource {
  Future<String> fetchBotResponse(String message) async {
    print(message);
    final response = await http.post(
      Uri.parse(Env.huggingfaceApiUrl),
      headers: {
        "Authorization": "Bearer ${Env.huggingfaceApiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data.isNotEmpty &&
          data[0] is Map<String, dynamic> &&
          data[0].containsKey('generated_text')) {
        return data[0]['generated_text'] as String;
      }
      return "No response from bot.";
    } else {
      return "Error: Unable to fetch response.";
    }
  }

  Future<String> getBotResponse(List<Map<String, String>> messages) async {
    // Format messages for OpenAI API
    List<Map<String, String>> formattedMessages = [
      {
        "role": "system",
        "content": "You are a helpful teacher in islamic studies, act like the companion Bilel of the prophet muhammed, "
            "especially understanding and explaining Quran. Only answer questions related to islam,  "
            "Quran, Prophet Muhammed, Allah, Prayers, Islamic habbits, Religion . Ignore unrelated topics."
            "If the user asks about a specific surah, provide the surah name, number of verses, and a brief explanation of the surah."
      },
      ...messages.map((msg) {
        return {"role": msg['role']!, "content": msg['content']!};
      }), // Keep previous user messages for context
    ];

    // API request body
    final Map<String, dynamic> requestBody = {
      "model": Env.openaiModel,
      "messages": formattedMessages,
      "temperature": 0 // Adjust for creativity (0 = strict, 1 = very random)
    };

    final response = await http.post(
      Uri.parse(Env.openaiApiUrl),
      headers: {
        "Authorization": "Bearer ${Env.openaiApiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["choices"][0]["message"]["content"];
    } else {
      throw Exception("Failed to fetch response: ${response.body}");
    }
  }

  Future<String> getTafssir(String message) async {
    // Format messages for OpenAI API
    List<Map<String, String>> formattedMessages = [
      {
        "role": "system",
        "content": "You are a helpful teacher in islamic studies, "
            "especially understanding and explaining Quran.Provide needed information about this verse and explain this verse for me in simple terms: ${message}"
      },
    ];

    // API request body
    final Map<String, dynamic> requestBody = {
      "model": Env.openaiModel,
      "messages": formattedMessages,
      "temperature": 0 // Adjust for creativity (0 = strict, 1 = very random)
    };

    final response = await http.post(
      Uri.parse(Env.openaiApiUrl),
      headers: {
        "Authorization": "Bearer ${Env.openaiApiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["choices"][0]["message"]["content"];
    } else {
      throw Exception("Failed to fetch response: ${response.body}");
    }
  }
}
