import 'package:flutter/foundation.dart';

class ChatHistory {
  final String id;
  final String title;
  final List<Map<String, String>> messages;
  final DateTime timestamp;

  ChatHistory({
    required this.id,
    required this.title,
    required this.messages,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List).map((message) {
        return Map<String, String>.from(message);
      }).toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
