class VerseResponse {
  final int verseNumber;
  final String arabicText;
  final int surahNumber;
  final String surahNameArabic;
  final String surahNameEnglish;
  final int numberInSurah;

  VerseResponse({
    required this.verseNumber,
    required this.arabicText,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.numberInSurah,
  });

  factory VerseResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final surah = data['surah'];

    return VerseResponse(
      verseNumber: data['number'],
      arabicText: data['text'],
      surahNumber: surah['number'],
      surahNameArabic: surah['name'],
      surahNameEnglish: surah['englishName'],
      numberInSurah: data['numberInSurah'],
    );
  }
}
