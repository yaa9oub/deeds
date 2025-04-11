import '../entities/prayer_timing.dart';
import '../repositories/prayer_timing_repository.dart';

class GetPrayerTimingsUseCase {
  final PrayerTimingRepository repository;

  GetPrayerTimingsUseCase(this.repository);

  Future<List<PrayerTiming>> call(String city, String country) async {
    return await repository.getPrayerTimings(city, country);
  }
}
