import '../entities/surah_entity.dart';

abstract class SurahRepository {
  Future<SurahEntity> getSurah(int surahId);
}
