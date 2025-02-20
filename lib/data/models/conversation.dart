class Conversation {
  List<Map<String, String>> messages = [];

  void addMessage(String role, String content) {
    messages.add({'role': role, 'content': content});
  }

  String getFormattedConversation() {
    return messages
        .map((message) => "${message['role']}: ${message['content']}")
        .join('\n');
  }
}
