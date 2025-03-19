import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ChatRemoteDataSource {
  final String apiUrl =
      "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill";
  final String apiKey =
      "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"; // Replace with your key

  Future<String> fetchBotResponse(String message) async {
    print(message);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
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
    final String apiKey =
        "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"; // Replace with your API key
    final String model = "gpt-3.5-turbo"; // Use gpt-4 if needed
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

    // Format messages for OpenAI API
    List<Map<String, String>> formattedMessages = [
      {
        "role": "system",
        "content": "You are a helpful teacher in islamic studies, in 50 words max, "
            "especially understanding and explaining Quran. Only answer questions related to islam,  "
            "Quran, Prophet Muhammed, Allah, Prayers, Islamic habbits, Religion . Ignore unrelated topics."
      },
      ...messages.map((msg) {
        return {"role": msg['role']!, "content": msg['content']!};
      }), // Keep previous user messages for context
    ];

    // API request body
    final Map<String, dynamic> requestBody = {
      "model": model,
      "messages": formattedMessages,
      "temperature": 0.7 // Adjust for creativity (0 = strict, 1 = very random)
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
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
    final String apiKey =
        "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"; // Replace with your API key
    final String model = "gpt-3.5-turbo"; // Use gpt-4 if needed
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

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
      "model": model,
      "messages": formattedMessages,
      "temperature": 0 // Adjust for creativity (0 = strict, 1 = very random)
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
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
}
