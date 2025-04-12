import 'package:dio/dio.dart';
import 'package:timezone/timezone.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/notifications.dart';
import '../../domain/entities/prayer_timing.dart';
import '../../domain/repositories/prayer_timing_repository.dart';

class PrayerTimingRepositoryImpl implements PrayerTimingRepository {
  final Dio _dio;
  final NotificationService _notificationService;

  PrayerTimingRepositoryImpl(this._dio, this._notificationService);

  @override
  Future<List<PrayerTiming>> getPrayerTimings(
      String city, String country) async {
    try {
      final response = await _dio.get(
        'https://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': city,
          'country': country,
        },
      );

      final data = response.data['data']['timings'];

      return [
        PrayerTiming(
            label: "Imsak", icon: AppAssets.imsak, time: data['Imsak']),
        PrayerTiming(label: "Fajr", icon: AppAssets.fajr, time: data['Fajr']),
        PrayerTiming(
            label: "Sunrise", icon: AppAssets.sun, time: data['Sunrise']),
        PrayerTiming(
            label: "Dhuhr", icon: AppAssets.dhuhr, time: data['Dhuhr']),
        PrayerTiming(label: "Asr", icon: AppAssets.asr, time: data['Asr']),
        PrayerTiming(
            label: "Maghrib", icon: AppAssets.maghreb, time: data['Maghrib']),
        PrayerTiming(label: "Isha", icon: AppAssets.icha, time: data['Isha']),
      ];
    } catch (e) {
      throw Exception('Failed to fetch prayer timings: $e');
    }
  }

  @override
  Future<void> togglePrayerAlarm(int index, bool isAlarm) async {
    if (isAlarm) {
      // This will be handled by the controller
      // The controller has access to the prayer timing data
      return;
    } else {
      await _notificationService.cancelNotification(index * 2 + 1);
    }
  }

  @override
  Future<void> togglePrayerReminder(int index, bool isReminder) async {
    if (isReminder) {
      // This will be handled by the controller
      // The controller has access to the prayer timing data
      return;
    } else {
      await _notificationService.cancelNotification(index * 2 + 2);
    }
  }

  @override
  Future<List<PrayerTiming>> getCurrentPrayerTimings() async {
    // Implementation for getting current prayer timings
    // This could be from local storage or a cache
    return [];
  }
}
