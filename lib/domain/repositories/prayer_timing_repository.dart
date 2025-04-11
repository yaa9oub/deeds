import '../entities/prayer_timing.dart';

abstract class PrayerTimingRepository {
  Future<List<PrayerTiming>> getPrayerTimings(String city, String country);
  Future<void> togglePrayerAlarm(int index, bool isAlarm);
  Future<void> togglePrayerReminder(int index, bool isReminder);
  Future<List<PrayerTiming>> getCurrentPrayerTimings();
}
