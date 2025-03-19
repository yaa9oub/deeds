import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/surah_entity.dart';

class SharedPrefService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (Call this once in main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveFavoriteVerses(List<VerseEntity> verses) async {
    List<String> versesJsonList =
        verses.map((verse) => jsonEncode(verse.toJson())).toList();
    await _prefs?.setStringList("favVerses", versesJsonList);
  }

  static List<VerseEntity> getFavoriteVerses() {
    List<String>? versesJsonList = _prefs?.getStringList("favVerses");
    if (versesJsonList == null) return [];

    return versesJsonList
        .map((verseJson) => VerseEntity.fromJson(jsonDecode(verseJson)))
        .toList();
  }

  static Future<void> addFavoriteVerse(VerseEntity verse) async {
    List<VerseEntity> favVerses = getFavoriteVerses();
    favVerses.add(verse);
    await saveFavoriteVerses(favVerses);
  }

  static Future<void> removeFavoriteVerse(int verseId) async {
    List<VerseEntity> favVerses = getFavoriteVerses();
    favVerses.removeWhere((v) => v.number == verseId);
    await saveFavoriteVerses(favVerses);
  }

  static bool isFavorite(int verseId, String surahName) {
    List<VerseEntity> favVerses = getFavoriteVerses();
    return favVerses
        .any((v) => v.number == verseId && v.surahName == surahName);
  }

  /// Save String
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get String
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save Int
  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get Int
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Save Bool
  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get Bool
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Save Double
  static Future<void> saveDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  /// Get Double
  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  /// Save List<String>
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  /// Get List<String>
  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// Remove a key
  static Future<void> removeKey(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
