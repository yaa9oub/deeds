import '../entities/surah_entity.dart';
import '../entities/verse_entity.dart';

abstract class SurahRepository {
  Future<SurahEntity> getSurah(int surahId);
  Future<QuranVerseEntity> getVerseByNumber(int verseNumber);
}
