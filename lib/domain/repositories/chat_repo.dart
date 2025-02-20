abstract class ChatRepository {
  Future<String> fetchBotResponse(String message);
  Future<String> getBotResponse(List<Map<String, String>> message);
  Future<String> getTafssir(String message);
}
