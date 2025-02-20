import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/presentation/chat/chat_page.dart';
import 'package:get/get.dart';

import '../../presentation/home/home_page.dart';
import '../../presentation/read/read_page.dart';
import '../../presentation/splash/splash_page.dart';
import '../bindings/bindings.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.read,
      page: () => const ReadPage(),
      binding: ReadBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
  ];
}
