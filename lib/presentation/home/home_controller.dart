import 'dart:async';
import 'dart:convert';

import 'package:deeds/core/constants/all_surahs.dart';
import 'package:deeds/core/constants/assets.dart';
import 'package:deeds/core/constants/consts.dart';
import 'package:deeds/core/services/location_service.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

import '../../core/utils/notifications.dart';
import '../../data/models/prayer.dart';
import '../../domain/entities/prayer_timing.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/usecases/get_prayer_timings_usecase.dart';

class HomeController extends GetxController {
  final GetPrayerTimingsUseCase _getPrayerTimingsUseCase;
  final LocationService _locationService = Get.find<LocationService>();

  HomeController(this._getPrayerTimingsUseCase);

  // overview variables
  final Rx<int> deeds = 0.obs;
  final Rx<int> surahsNumber = 0.obs;
  final Rx<int> pages = 0.obs;
  // last read variables
  final Rx<int> verseNumber = 1.obs;
  final Rx<int> surahNumber = 1.obs;
  final Rx<String> surahName = "Surah name".obs;
  final Rx<int> surahLength = 7.obs;
  //prayers list variables
  final Rx<String> city = "".obs;
  final RxList<PrayerTiming> prayers = <PrayerTiming>[].obs;
  final Rx<SurahEntity?> surah = Rx<SurahEntity?>(null);
  // surah selector variables
  final Rx<int> selectedSurah = 1.obs;
  final Rx<int> selectedVerse = 1.obs;

  final Rx<bool> isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initializeData();
  }

  Future<void> _initializeData() async {
    // Get current location
    await _locationService.getCurrentLocation();

    // Load saved city or use current location
    city.value = SharedPrefService.getString(LocalVariables.city.name) ??
        _locationService.currentCity;

    // Search for location using current city
    await searchForLocation(city.value);

    _loadPrayerToggleStates();
    _loadSavedData();
  }

  void _loadSavedData() {
    //last read variables initialization
    surahName.value =
        SharedPrefService.getString(LocalVariables.surahName.name) ??
            surahs[0]["name"];
    surahNumber.value =
        SharedPrefService.getInt(LocalVariables.surahNumber.name) ??
            surahs[0]["id"];
    surahLength.value =
        SharedPrefService.getInt(LocalVariables.surahLength.name) ??
            surahs[0]["verses"];
    verseNumber.value =
        SharedPrefService.getInt(LocalVariables.verseNumber.name) ?? 1;
    // overview variables initialization
    deeds.value = SharedPrefService.getInt(LocalVariables.deeds.name) ?? 0;
    surahsNumber.value =
        SharedPrefService.getInt(LocalVariables.surahs.name) ?? 0;
    pages.value = SharedPrefService.getInt(LocalVariables.pages.name) ?? 0;
  }

  // Load prayer toggle states from SharedPrefs
  void _loadPrayerToggleStates() {
    final savedAlarms = SharedPrefService.getString("prayer_alarms");
    final savedReminders = SharedPrefService.getString("prayer_reminders");

    if (savedAlarms != null && savedReminders != null) {
      final alarmMap = jsonDecode(savedAlarms) as Map<String, dynamic>;
      final reminderMap = jsonDecode(savedReminders) as Map<String, dynamic>;

      // Apply saved states to prayers
      for (int i = 0; i < prayers.length; i++) {
        final prayer = prayers[i];
        final prayerKey = "${prayer.label}_${prayer.time}";

        final isAlarm = alarmMap[prayerKey] ?? false;
        final isReminder = reminderMap[prayerKey] ?? false;

        prayers[i] = prayer.copyWith(
          isAlarm: isAlarm,
          isReminder: isReminder,
        );
      }
      prayers.refresh();
    }
  }

  // Save prayer toggle states to SharedPrefs
  void _savePrayerToggleStates() {
    final alarmMap = <String, bool>{};
    final reminderMap = <String, bool>{};

    for (final prayer in prayers) {
      final prayerKey = "${prayer.label}_${prayer.time}";
      alarmMap[prayerKey] = prayer.isAlarm;
      reminderMap[prayerKey] = prayer.isReminder;
    }

    SharedPrefService.saveString("prayer_alarms", jsonEncode(alarmMap));
    SharedPrefService.saveString("prayer_reminders", jsonEncode(reminderMap));
  }

  Future<void> searchForLocation(String city) async {
    isLoading.value = true;
    try {
      final prayerTimings = await _getPrayerTimingsUseCase.call(
          city, _locationService.currentCountry);
      prayers.value = prayerTimings;

      // Save the selected city
      await SharedPrefService.saveString(LocalVariables.city.name, city);
      this.city.value = city;

      // After loading new prayer timings, apply saved toggle states
      _loadPrayerToggleStates();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch prayer timings',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAlarm(int index) {
    final prayer = prayers[index];
    prayers[index] = prayer.copyWith(isAlarm: !prayer.isAlarm);
    prayers.refresh();

    // Save the updated state
    _savePrayerToggleStates();

    // Schedule or cancel notification
    if (prayers[index].isAlarm) {
      schedulePrayerNotification(
        Prayer(
          label: prayer.label,
          icon: prayer.icon,
          time: prayer.time,
          isAlarm: true,
          isReminder: prayer.isReminder,
        ),
        index,
        isReminder: false,
      );
    } else {
      NotificationService().cancelNotification(index * 2 + 1);
    }
  }

  void toggleReminder(int index) {
    final prayer = prayers[index];
    prayers[index] = prayer.copyWith(isReminder: !prayer.isReminder);
    prayers.refresh();

    // Save the updated state
    _savePrayerToggleStates();

    // Schedule or cancel notification
    if (prayers[index].isReminder) {
      schedulePrayerNotification(
        Prayer(
          label: prayer.label,
          icon: prayer.icon,
          time: prayer.time,
          isAlarm: prayer.isAlarm,
          isReminder: true,
        ),
        index,
        isReminder: true,
      );
    } else {
      NotificationService().cancelNotification(index * 2 + 2);
    }
  }

  void schedulePrayerNotification(Prayer prayer, int id,
      {required bool isReminder}) async {
    try {
      List<String> timeParts = prayer.time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime now = DateTime.now();
      DateTime prayerTime =
          DateTime(now.year, now.month, now.day, hour, minute);
      DateTime beforePrayerTime = prayerTime.subtract(Duration(minutes: 15));

      TZDateTime tzTime =
          TZDateTime.from(isReminder ? beforePrayerTime : prayerTime, local);
      int notificationId = isReminder ? id * 2 : (id * 2) + 1;

      await NotificationService().schedulePrayerNotification(
        id: notificationId,
        title:
            isReminder ? "${prayer.label} Reminder" : "${prayer.label} Time!",
        body: isReminder
            ? "Time for ${prayer.label} is approaching in 15 minutes."
            : "It's time for ${prayer.label} prayer.",
        scheduledTime: tzTime,
      );

      print(
          "✅ Scheduled ${isReminder ? "Reminder" : "Alarm"} for ${prayer.label} at $tzTime");
    } catch (e) {
      print("❌ Error scheduling ${prayer.label}: $e");
    }
  }
}
