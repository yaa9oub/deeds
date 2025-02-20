class Verse {
  final int number;
  final String text; // Arabic text
  final String translation; // English translation
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  Verse({
    required this.number,
    required this.text,
    required this.translation,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      text: json['text'],
      translation: '', // Placeholder, to be filled later
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'] ?? false,
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<Verse> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    List<Verse> verses =
        (json['ayahs'] as List).map((e) => Verse.fromJson(e)).toList();
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: verses,
    );
  }
}
