import 'package:deeds/core/utils/notifications.dart';
import 'package:deeds/data/repositories/prayer_timing_repository_impl.dart';
import 'package:deeds/domain/repositories/prayer_timing_repository.dart';
import 'package:deeds/domain/repositories/surah_repo.dart';
import 'package:deeds/domain/usecases/get_prayer_timings_usecase.dart';
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

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register Dio instance
    Get.lazyPut<Dio>(() => Dio());

    // Register NotificationService
    Get.lazyPut<NotificationService>(() => NotificationService());

    // Register SurahDataSource and Repository
    Get.lazyPut(() => SurahDataSource(Get.find<Dio>()));
    Get.lazyPut<SurahRepository>(
      () => SurahRepositoryImpl(Get.find<SurahDataSource>()),
    );

    // Register PrayerTimingRepository
    Get.lazyPut<PrayerTimingRepository>(
      () => PrayerTimingRepositoryImpl(
        Get.find<Dio>(),
        Get.find<NotificationService>(),
      ),
    );

    // Register GetPrayerTimingsUseCase
    Get.lazyPut<GetPrayerTimingsUseCase>(
      () => GetPrayerTimingsUseCase(Get.find<PrayerTimingRepository>()),
    );

    // Register HomeController
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetPrayerTimingsUseCase>()),
    );
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
