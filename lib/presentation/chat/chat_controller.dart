import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/chat_history.dart';
import '../../domain/repositories/chat_repo.dart';
import '../../core/utils/shared_prefs.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;
  ChatController(this.chatRepository);

  final Map<String, String> topicSuggestions = {
    "Allah": "Explain who Allah is in Islam.",
    "Heaven": "Describe what Heaven is in Islam.",
    "Quran": "Explain what the Quran is in Islam.",
    "Prayers": "Tell me what prayers are in Islam.",
    "Prophet Muhammad": "Explain who Prophet Muhammad is in Islam.",
    "Angels": "Tell me what angels are in Islam.",
    "Islam": "Explain what Islam is in Islam.",
    "Mosque": "Describe what a mosque is in Islam.",
    "Ramadan": "Tell me about Ramadan in Islam.",
    "Charity": "Explain what charity is in Islam.",
    "Kindness": "Describe the meaning of kindness in Islam.",
    "Hajj": "Explain what Hajj is in Islam.",
    "Prophets": "Tell me what prophets are in Islam.",
    "Paradise": "Explain what Paradise is in Islam.",
    "Faith": "Describe what faith means in Islam.",
    "Fasting": "Explain what fasting is in Islam.",
    "Zakat": "Tell me what Zakat is in Islam.",
    "The Kaaba": "Explain what the Kaaba is in Islam.",
    "Good Deeds": "Tell me about good deeds in Islam.",
    "Respect": "Describe what respect means in Islam.",
  };

  var messages = <Map<String, String>>[].obs;
  var isLoading = false.obs;
  var savedChats = <ChatHistory>[].obs;
  String? currentChatId;
  int requestCount = 0;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadSavedChats();
    loadRequestCount();
  }

  void loadRequestCount() async {
    requestCount = SharedPrefService.getInt('chat_request_count') ?? 0;
  }

  void incrementRequestCount() async {
    requestCount++;
    await SharedPrefService.saveInt('chat_request_count', requestCount);

    if (requestCount % 3 == 0) {
      showSupportDialog();
    }
  }

  void showSupportDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "The app is totally free",
                style: AppTextStyles.midBoldText,
              ),
              SizedBox(height: 10.h),
              Text(
                "Your contribution will help me keep on improving the app",
                style: AppTextStyles.smallBoldText.copyWith(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Maybe Later",
                      style: AppTextStyles.smallBoldText.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    label: "Contribute",
                    onPressed: () async {
                      try {
                        final Uri url =
                            Uri.parse('https://yaa9oub.github.io/portfolio/');
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not open the contribution link. Please try again later.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.1),
                          colorText: Colors.red,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSavedChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsJson = prefs.getStringList('saved_chats') ?? [];
    savedChats.value = chatsJson.map((json) {
      final Map<String, dynamic> decoded = jsonDecode(json);
      return ChatHistory.fromJson(decoded);
    }).toList();
  }

  Future<void> saveCurrentChat() async {
    if (messages.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final uuid = currentChatId ?? const Uuid().v4();
    currentChatId = uuid;

    // Generate title from first message
    final firstMessage = messages.first['content'] ?? '';
    final title = firstMessage.length > 30
        ? '${firstMessage.substring(0, 30)}...'
        : firstMessage;

    final chatHistory = ChatHistory(
      id: uuid,
      title: title,
      messages: messages.toList(),
      timestamp: DateTime.now(),
    );

    // Remove existing chat if it exists
    savedChats.removeWhere((chat) => chat.id == uuid);
    savedChats.add(chatHistory);

    final chatsJson =
        savedChats.map((chat) => jsonEncode(chat.toJson())).toList();
    await prefs.setStringList('saved_chats', chatsJson);
  }

  void loadChat(ChatHistory chat) {
    messages.value = chat.messages;
    currentChatId = chat.id;
  }

  void startNewChat() {
    messages.clear();
    currentChatId = null;
  }

  void deleteChat(String id) async {
    savedChats.removeWhere((chat) => chat.id == id);
    final prefs = await SharedPreferences.getInstance();
    final chatsJson =
        savedChats.map((chat) => jsonEncode(chat.toJson())).toList();
    await prefs.setStringList('saved_chats', chatsJson);
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

/*
  void sendHuggingMessage(String text) async {
    if (text.isEmpty) return;

    // Add user's message to the history
    messages.add({'role': 'user', 'content': text});
    isLoading.value = true;

    // Define the context or instruction to guide the assistant towards software topics
    String assistantContext =
        "You are a software engineer and you are helping me to write a flutter app.";

    // Prepend the context to the conversation history
    String conversationHistory = _getConversationHistory();
    conversationHistory = "$assistantContext\n$conversationHistory";

    // Send the conversation history to the repository for a response
    final response = await chatRepository.fetchBotResponse(conversationHistory);

    // Add bot's response to the conversation history
    messages.add({'role': 'bot', 'content': response});
    isLoading.value = false;
  }
*/
  void sendMessage(String text) async {
    if (text.isEmpty) return;

    messages.add({'role': 'user', 'content': text});

    // Keep only last 10 messages (OpenAI has a token limit)
    if (messages.length > 10) {
      messages.removeAt(0);
    }

    isLoading.value = true;

    try {
      final response = await chatRepository.getBotResponse(messages);
      messages.add({'role': 'assistant', 'content': response});
      // Auto-save after each message
      await saveCurrentChat();
      // Increment request counter
      incrementRequestCount();
    } catch (e) {
      messages.add(
          {'role': 'assistant', 'content': 'Error: Failed to get response.'});
    }

    isLoading.value = false;
  }

  // Function to format the conversation history for the API request
  String _getConversationHistory() {
    return messages.map((message) {
      return "${message['role']}: ${message['content']}";
    }).join("\n");
  }
}
