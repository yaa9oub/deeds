import 'dart:async';
import 'dart:convert';

import 'package:deeds/core/constants/assets.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

import '../../core/utils/notifications.dart';
import '../../data/models/prayer.dart';
import '../../domain/entities/surah_entity.dart';

class HomeController extends GetxController {
  Rx<int> deeds = 0.obs;
  Rx<int> surahs = 0.obs;
  Rx<int> pages = 0.obs;
  Rx<int> verseNumber = 1.obs;
  Rx<bool> isLoading = false.obs;
  var prayers = <Prayer>[].obs;
  var surah = Rx<SurahEntity?>(null);
  Rx<Prayer> currentPrayer = Prayer(
          label: "label",
          icon: AppAssets.asr,
          time: "time",
          isAlarm: false,
          isReminder: false)
      .obs;
  Rx<Prayer> nextPrayer = Prayer(
          label: "label",
          icon: AppAssets.asr,
          time: "time",
          isAlarm: false,
          isReminder: false)
      .obs;

  Rx<String> city = "Sousse".obs;

  List<String> tunisianGovernorates = [
    "Tunis",
    "Sfax",
    "Sousse",
    "Ariana",
    "Monastir",
    "Kairouan",
    "Bizerte",
    "Gabès",
    "Kasserine",
    "Mednine",
    "Zaghouan",
    "Medenine",
    "Jendouba",
    "Tozeur",
    "Nabeul",
    "Mahdia",
    "Gafsa",
    "El Kef",
    "Siliana",
    "Tataouine",
    "Beja",
    "Ben Arous",
    "La Manouba",
    "Sidi Bouzid"
  ];

  var selectedValue = 1.obs; // Observable for selected value

  // Method to update the selected value
  void updateSelectedValue(int value) {
    selectedValue.value = value;
  }

  @override
  onInit() async {
    super.onInit();
    await searchForLocation("Sousse");

    if (SharedPrefService.getString("surah") != null) {
      surah.value = SurahEntity.fromJson(
          jsonDecode(SharedPrefService.getString("surah") ?? ""));
    }
    verseNumber.value = SharedPrefService.getInt("verseNumber") ?? 1;
    deeds.value = SharedPrefService.getInt("deeds") ?? 0;
    surahs.value = SharedPrefService.getInt("surahs") ?? 0;
    pages.value = SharedPrefService.getInt("pages") ?? 0;
  }

  Future<void> searchForLocation(String city) async {
    isLoading.value = true;
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': city,
          'country': 'Tunisia',
        },
      );

      final data = response.data['data']['timings'];

      List<Prayer> prayerTimes = [
        Prayer(label: "Imsak", icon: AppAssets.imsak, time: data['Imsak']),
        Prayer(label: "Fajr", icon: AppAssets.fajr, time: data['Fajr']),
        Prayer(label: "Sunrise", icon: AppAssets.sun, time: data['Sunrise']),
        Prayer(label: "Dhuhr", icon: AppAssets.dhuhr, time: data['Dhuhr']),
        Prayer(label: "Asr", icon: AppAssets.asr, time: data['Asr']),
        Prayer(
            label: "Maghrib", icon: AppAssets.maghreb, time: data['Maghrib']),
        Prayer(label: "Isha", icon: AppAssets.icha, time: data['Isha']),
      ];

      prayers.value = prayerTimes;
    } catch (e) {
      print('Error: $e');
    }
    isLoading.value = false;
  }

  void toggleAlarm(int index) {
    prayers[index].isAlarm = !prayers[index].isAlarm;
    prayers.refresh(); // Update UI
    if (prayers[index].isAlarm) {
      schedulePrayerNotification(prayers[index], index, isReminder: false);
    } else {
      NotificationService()
          .cancelNotification(index * 2 + 1); // Cancel exact time alarm
    }
  }

  void toggleReminder(int index) {
    prayers[index].isReminder = !prayers[index].isReminder;
    prayers.refresh(); // Update UI
    if (prayers[index].isReminder) {
      schedulePrayerNotification(prayers[index], index, isReminder: true);
    } else {
      NotificationService().cancelNotification(index * 2); // Cancel reminder
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
