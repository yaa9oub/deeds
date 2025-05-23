import 'package:deeds/core/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_urls.dart';
import 'core/utils/shared_prefs.dart';
import 'core/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize timezones
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await NotificationService().initNotification();
  await SharedPrefService.init();

  // Initialize location service
  await Get.putAsync(() => LocationService().init());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.pink.shade100.withAlpha(5),
        statusBarIconBrightness: Brightness.values[1],
        statusBarBrightness: Brightness.light,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        theme: getTheme(context),
        defaultTransition: Transition.fade,
      ),
    );
  }
}

ThemeData getTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink.shade100,
      brightness: Brightness.light,
    ),
  );
}
