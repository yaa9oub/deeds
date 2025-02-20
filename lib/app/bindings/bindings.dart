import 'package:deeds/domain/repositories/surah_repo.dart';
import 'package:deeds/presentation/chat/chat_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../data/datasources/chat_datasource.dart';
import '../../data/datasources/surah_datasource.dart';
import '../../data/repositories/chat_repo_impl.dart';
import '../../data/repositories/surah_repo_impl.dart';
import '../../domain/repositories/chat_repo.dart';
import '../../domain/usecases/get_surah_usecase.dart';
import '../../presentation/home/home_controller.dart';
import '../../presentation/read/read_controller.dart';
import '../../presentation/splash/splash_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class ReadBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy-load Dio
    Get.lazyPut(() => Dio());

    // Lazy-load data layer dependencies
    Get.lazyPut<SurahDataSource>(() => SurahDataSource(Get.find()));

    // Lazy-load repository
    Get.lazyPut<SurahRepository>(() => SurahRepositoryImpl(Get.find()));

    // Lazy-load use case
    Get.lazyPut<GetSurahUseCase>(() => GetSurahUseCase(Get.find()));

    Get.put(ChatRemoteDataSource());
    Get.put<ChatRepository>(
        ChatRepositoryImpl(Get.find<ChatRemoteDataSource>()));

    // Lazy-load the controller
    Get.lazyPut<ReadController>(() => ReadController(Get.find(), Get.find()));
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChatRemoteDataSource());
    Get.put<ChatRepository>(
        ChatRepositoryImpl(Get.find<ChatRemoteDataSource>()));

    Get.lazyPut<ChatController>(() => ChatController(Get.find()));
  }
}
