import 'package:deeds/data/datasources/chat_datasource.dart';

import '../../domain/repositories/chat_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> fetchBotResponse(String message) async {
    return await remoteDataSource.fetchBotResponse(message);
  }

  @override
  Future<String> getBotResponse(List<Map<String, String>> message) async {
    return await remoteDataSource.getBotResponse(message);
  }

  @override
  Future<String> getTafssir(String message) async {
    return await remoteDataSource.getTafssir(message);
  }
}
