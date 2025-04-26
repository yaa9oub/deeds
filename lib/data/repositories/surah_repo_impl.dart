import '../../domain/entities/surah_entity.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/repositories/surah_repo.dart';
import '../datasources/surah_datasource.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahDataSource surahDataSource;

  SurahRepositoryImpl(this.surahDataSource);

  @override
  Future<SurahEntity> getSurah(int surahId) async {
    final surahModel = await surahDataSource.getSurah(surahId);
    return SurahEntity(
      number: surahModel.number,
      name: surahModel.name,
      englishName: surahModel.englishName,
      englishNameTranslation: surahModel.englishNameTranslation,
      ayahs: surahModel.ayahs
          .map(
            (e) => VerseEntity(
              number: e.number,
              page: e.page,
              text: e.text,
              translation: e.translation,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<QuranVerseEntity> getVerseByNumber(int verseNumber) async {
    final verseResponse = await surahDataSource.getVerseByNumber(verseNumber);
    return QuranVerseEntity(
      verseNumber: verseResponse.verseNumber,
      arabicText: verseResponse.arabicText,
      surahNumber: verseResponse.surahNumber,
      surahNameArabic: verseResponse.surahNameArabic,
      surahNameEnglish: verseResponse.surahNameEnglish,
      numberInSurah: verseResponse.numberInSurah,
    );
  }
}
