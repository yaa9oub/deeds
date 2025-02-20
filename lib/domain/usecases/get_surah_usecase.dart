import '../entities/surah_entity.dart';
import '../repositories/surah_repo.dart';

class GetSurahUseCase {
  final SurahRepository surahRepository;

  GetSurahUseCase(this.surahRepository);

  Future<SurahEntity> call(int surahId) async {
    return await surahRepository.getSurah(surahId);
  }
}
