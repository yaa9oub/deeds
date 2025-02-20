import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/assets.dart';
import '../../data/models/prayer.dart';

class CurrentPrayerController extends GetxController {
  Rx<Prayer> currentPrayer = Prayer(
    label: "Loading...",
    icon: AppAssets.sun,
    time: "00:00",
    isAlarm: false,
    isReminder: false,
  ).obs;

  Rx<Prayer> nextPrayer = Prayer(
    label: "Loading...",
    icon: AppAssets.maghreb,
    time: "23:00",
    isAlarm: false,
    isReminder: false,
  ).obs;

  RxList<Prayer> prayers = <Prayer>[].obs;
  ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  Timer? _timer;

  @override
  void onInit() async {
    super.onInit();
    await fetchPrayerTimes("Sousse");
    startProgressUpdate();
  }

  Future<void> fetchPrayerTimes(String city) async {
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
      updatePrayerTimes();
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
  }

  void updatePrayerTimes() {
    currentPrayer.value = getCurrentPrayer();
    nextPrayer.value = getNextPrayer();
  }

  Prayer getCurrentPrayer() {
    DateTime now = DateTime.now();
    for (int i = 0; i < prayers.length - 1; i++) {
      if (now.isBefore(prayers[i + 1].getDateTime())) {
        return prayers[i];
      }
    }
    return prayers.last;
  }

  Prayer getNextPrayer() {
    DateTime now = DateTime.now();
    for (int i = 0; i < prayers.length - 1; i++) {
      if (now.isBefore(prayers[i + 1].getDateTime())) {
        return prayers[i + 1];
      }
    }
    return prayers.first;
  }

  double getPrayerProgress() {
    DateTime now = DateTime.now();
    DateTime currentPrayerTime = currentPrayer.value.getDateTime();
    DateTime nextPrayerTime = nextPrayer.value.getDateTime();
    double progress = (now.difference(currentPrayerTime).inMinutes /
        nextPrayerTime.difference(currentPrayerTime).inMinutes);
    return progress.clamp(0.0, 1.0);
  }

  void startProgressUpdate() {
    _timer?.cancel();
    progressNotifier.value = getPrayerProgress();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (DateTime.now().isAfter(nextPrayer.value.getDateTime())) {
        updatePrayerTimes();
      }
      progressNotifier.value = getPrayerProgress();
      print(progressNotifier.value);
    });
  }

  double getBestTimeProgress(Prayer currentPrayer, Prayer nextPrayer) {
    double totalDuration = nextPrayer
        .getDateTime()
        .difference(currentPrayer.getDateTime())
        .inMinutes
        .toDouble();
    return (currentPrayer
            .getDateTime()
            .add(Duration(minutes: 30))
            .difference(currentPrayer.getDateTime())
            .inMinutes
            .toDouble()) /
        totalDuration;
  }

  double getWorstTimeProgress(Prayer currentPrayer, Prayer nextPrayer) {
    double totalDuration = nextPrayer
        .getDateTime()
        .difference(currentPrayer.getDateTime())
        .inMinutes
        .toDouble();
    return (nextPrayer
            .getDateTime()
            .subtract(Duration(minutes: 30))
            .difference(currentPrayer.getDateTime())
            .inMinutes
            .toDouble()) /
        totalDuration;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
