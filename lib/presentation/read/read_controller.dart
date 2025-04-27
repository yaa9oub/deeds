import 'dart:convert';

import 'package:deeds/core/constants/all_surahs.dart';
import 'package:deeds/core/constants/consts.dart';
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
  // local tracking variables
  Rx<int> currentDeeds = 0.obs;
  Rx<int> currentSurah = 0.obs;
  Rx<int> currentPage = 0.obs;
  int currentPageNumber = 0;
  // reading variables
  Rx<String> surahName = "Al-Fatihah".obs;
  Rx<int> surahNumber = 1.obs;
  Rx<int> verseNumber = 1.obs;
  Rx<int> surahLength = 7.obs;
  //fetched surah
  var surah = Rx<SurahEntity?>(null);
  //reading view variables
  int currentVersePage = 0;

  Rx<bool> isFavorite = false.obs;
  Rx<bool> isReadOnly = true.obs;

  //is surah completed
  Rx<bool> isSurahCompleted = false.obs;
  int verseIndex = 0;

  PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    // SharedPrefService.clearAll();
    // reading variables
    surahName.value =
        SharedPrefService.getString(LocalVariables.surahName.name) ??
            surahs[0]["name"];
    surahNumber.value =
        SharedPrefService.getInt(LocalVariables.surahNumber.name) ??
            surahs[0]["id"];
    surahLength.value =
        SharedPrefService.getInt(LocalVariables.surahLength.name) ??
            surahs[0]["verses"];
    verseNumber.value =
        SharedPrefService.getInt(LocalVariables.verseNumber.name) ?? 1;

    // favorites
    favoriteVerses = SharedPrefService.getFavoriteVerses();
    //fetch surah
    await fetchSurah(surahNumber.value);
    //this to handle the deeds caluculation
    currentVersePage = verseNumber.value - 1;
    currentPageNumber = surah.value!.ayahs[currentVersePage].page;
    //this to handle the page jump
    if (verseNumber.value == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.jumpToPage(0);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.jumpToPage(verseNumber.value - 1);
      });
    }
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
    //next surah
    if (surahNumber.value < surahs.length) {
      surahNumber.value = surahNumber.value + 1;
      surahLength.value = surahs[surahNumber.value - 1]["verses"];
      surahName.value = surahs[surahNumber.value - 1]["name"];
      verseNumber.value = 1;
      currentSurah.value++;
    } else {
      surahNumber.value = 1;
      surahLength.value = surahs[surahNumber.value - 1]["verses"];
      surahName.value = surahs[surahNumber.value - 1]["name"];
      verseNumber.value = 1;
      currentSurah.value = currentSurah.value + 1;
    }

    //fetch next surah
    currentVersePage = 0;
    await fetchSurah(surahNumber.value);
    saveCurrentReading();
  }

  Future<void> readVerse(currentVerseId) async {
    int surahLength = surah.value!.ayahs.length;
    if (currentVerseId < surahLength) {
      verseNumber.value = currentVerseId + 1;
    }

    if (currentVerseId != 0) {
      currentPage.value =
          surah.value!.ayahs[currentVerseId - 1].page - currentPageNumber;
    } else {
      currentPage.value = 0;
    }
    if (currentVerseId <= surahLength && currentVerseId - 1 >= 0) {
      if (currentVersePage < currentVerseId) {
        currentVersePage = currentVerseId;
        currentDeeds.value = currentDeeds.value +
            removeTashkeel(surah.value!.ayahs[currentVerseId - 1].text)
                    .replaceAll(" ", "")
                    .length *
                10;
      }
    }

    saveCurrentReading();
  }

  String removeTashkeel(String input) {
    final RegExp tashkeelRegex =
        RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]');
    return input.replaceAll(tashkeelRegex, '');
  }

  void saveCurrentReading() {
    SharedPrefService.saveInt(
        LocalVariables.surahNumber.name, surahNumber.value);
    SharedPrefService.saveInt(
        LocalVariables.verseNumber.name, verseNumber.value);
    SharedPrefService.saveString(
        LocalVariables.surahName.name, surahName.value);
    SharedPrefService.saveInt(
        LocalVariables.surahLength.name, surahLength.value);
  }

  void saveProgress() {
    //save the deeds
    var oldDeeds = SharedPrefService.getInt(LocalVariables.deeds.name);
    if (oldDeeds == null) {
      SharedPrefService.saveInt(LocalVariables.deeds.name, currentDeeds.value);
    } else {
      SharedPrefService.saveInt(
        LocalVariables.deeds.name,
        oldDeeds + currentDeeds.value,
      );
    }
    //save the pages
    var oldPages = SharedPrefService.getInt(LocalVariables.pages.name);
    if (oldPages == null) {
      SharedPrefService.saveInt(LocalVariables.pages.name, currentPage.value);
    } else {
      SharedPrefService.saveInt(
          LocalVariables.pages.name, oldPages + currentPage.value);
    }
    //save the surahs
    var oldSurahs = SharedPrefService.getInt(LocalVariables.surahs.name);
    if (oldSurahs == null) {
      SharedPrefService.saveInt(LocalVariables.surahs.name, currentSurah.value);
    } else {
      SharedPrefService.saveInt(
          LocalVariables.surahs.name, oldSurahs + currentSurah.value);
    }
  }
}
