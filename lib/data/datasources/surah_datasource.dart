import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/surah_model.dart';

class SurahDataSource {
  final Dio dio;

  SurahDataSource(this.dio);

  // Future<Surah> getSurah(int surahId) async {
  //   final response = await dio.get(
  //     'https://al-quran1.p.rapidapi.com/$surahId',
  //     // queryParameters: {'id': surahId},
  //     options: Options(
  //       headers: {
  //         'x-rapidapi-host': 'al-quran1.p.rapidapi.com',
  //         'x-rapidapi-key':
  //             '2d5b88276emsh6e8216a5b3f8e0cp1e2c7fjsn58c6a1768bf0',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return Surah.fromJson(response.data);
  //   } else {
  //     throw Exception('Failed to load surah');
  //   }
  // }

  Future<Surah> getSurah(int surahNumber) async {
    final arabicResponse =
        await dio.get('https://api.alquran.cloud/v1/surah/$surahNumber');
    final englishResponse = await dio
        .get('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad');

    if (arabicResponse.statusCode == 200 && englishResponse.statusCode == 200) {
      final arabicData = arabicResponse.data["data"];
      final englishData = englishResponse.data["data"];

      Surah arabicSurah = Surah.fromJson(arabicData);
      List<Verse> englishVerses =
          (englishData['ayahs'] as List).map((e) => Verse.fromJson(e)).toList();

      // Merge translations into Arabic verses
      for (int i = 0; i < arabicSurah.ayahs.length; i++) {
        arabicSurah.ayahs[i] = Verse(
          number: arabicSurah.ayahs[i].number,
          text: arabicSurah.ayahs[i].text,
          translation: englishVerses[i].text,
          numberInSurah: arabicSurah.ayahs[i].numberInSurah,
          juz: arabicSurah.ayahs[i].juz,
          manzil: arabicSurah.ayahs[i].manzil,
          page: arabicSurah.ayahs[i].page,
          ruku: arabicSurah.ayahs[i].ruku,
          hizbQuarter: arabicSurah.ayahs[i].hizbQuarter,
          sajda: arabicSurah.ayahs[i].sajda,
        );
      }

      return arabicSurah;
    } else {
      throw Exception('Failed to load Surah');
    }
  }
}
