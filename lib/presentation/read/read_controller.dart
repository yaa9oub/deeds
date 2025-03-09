import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_prefs.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/chat_repo.dart';
import '../../domain/usecases/get_surah_usecase.dart';

class ReadController extends GetxController {
  final GetSurahUseCase getSurahUseCase;
  final ChatRepository chatRepository;

  ReadController(this.getSurahUseCase, this.chatRepository);

  var tafsirText = "".obs;
  var isLoading = false.obs;

  List<VerseEntity> favoriteVerses = [];

  var surah = Rx<SurahEntity?>(null);
  Rx<int> surahNumber = 1.obs;
  Rx<int> verseNumber = 1.obs;
  Rx<int> deeds = 0.obs;
  Rx<int> surahs = 0.obs;
  Rx<int> page = 0.obs;
  int currentVersePage = 0;

  Rx<bool> isFavorite = false.obs;
  Rx<bool> isReadOnly = true.obs;

  PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    // SharedPrefService.clearAll();
    page.value = SharedPrefService.getInt("pages") ?? 0;
    favoriteVerses = SharedPrefService.getFavoriteVerses();
    surahNumber.value = SharedPrefService.getInt("surahNumber") ?? 1;
    await fetchSurah(surahNumber.value);
    verseNumber.value = SharedPrefService.getInt("verseNumber") ?? 1;
    currentVersePage = verseNumber.value - 1;
    if (verseNumber.value != 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.jumpToPage(verseNumber.value - 1);
      });
    }
    deeds.value = SharedPrefService.getInt("deeds") ?? 0;
    surahs.value = SharedPrefService.getInt("surahs") ?? 0;
  }

  Future<void> fetchSurah(int surahId) async {
    try {
      surah.value = null;
      surah.value = await getSurahUseCase.call(surahId);
    } catch (e) {
      print("Error fetching surah: $e");
    }
  }

  Future<void> fetchTafsir(String verse) async {
    isLoading.value = true;
    final tafsir = await chatRepository.getTafssir(verse);
    tafsirText.value = tafsir;
    isLoading.value = false;
  }

  Future<void> nextSurah() async {
    surahNumber.value = surah.value!.number + 1;
    verseNumber.value = 1;
    surahs.value = surah.value!.number;
    SharedPrefService.saveInt("surahNumber", surah.value!.number + 1);
    SharedPrefService.saveInt("verseNumber", verseNumber.value);
    SharedPrefService.saveInt("deeds", deeds.value);
    SharedPrefService.saveInt("surahs", surahs.value);
    currentVersePage = 0;
    fetchSurah(surahNumber.value);
  }

  Future<void> readVerse(currentVerseId) async {
    int surahLength = surah.value!.ayahs.length;
    if (currentVerseId < surahLength) {
      verseNumber.value = currentVerseId + 1;
    }

    if (currentVerseId <= surahLength && currentVerseId - 1 >= 0) {
      page.value = surah.value!.ayahs[currentVerseId - 1].page;
      if (currentVersePage < currentVerseId) {
        currentVersePage = currentVerseId;
        deeds.value = deeds.value +
            surah.value!.ayahs[currentVerseId - 1].text.length * 10;
      }
    }
    SharedPrefService.saveInt("deeds", deeds.value);
    SharedPrefService.saveInt("pages", page.value);
    SharedPrefService.saveInt("verseNumber", verseNumber.value);
    SharedPrefService.saveString("surah", jsonEncode(surah.value!.toJson()));
  }
}
