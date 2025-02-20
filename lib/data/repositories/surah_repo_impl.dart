import '../../domain/entities/surah_entity.dart';
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
}
