// Entity Classes (Domain Layer)
class VerseEntity {
  final int number;
  final String text;
  final String translation;
  final int page;

  VerseEntity({
    required this.page,
    required this.number,
    required this.text,
    required this.translation,
  });

  factory VerseEntity.fromJson(Map<String, dynamic> json) {
    return VerseEntity(
      number: json['number'],
      text: json['text'],
      translation: json['translation'],
      page: json['page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'translation': translation,
      'page': page,
    };
  }
}

class SurahEntity {
  int number;
  String name;
  String englishName;
  final String englishNameTranslation;
  final List<VerseEntity> ayahs;

  SurahEntity({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.ayahs,
  });

  factory SurahEntity.fromJson(Map<String, dynamic> json) {
    return SurahEntity(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      ayahs:
          (json['ayahs'] as List).map((e) => VerseEntity.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'ayahs': ayahs.map((e) => e.toJson()).toList(),
    };
  }
}

// Data Layer Models (Remote Source)
class VerseModel {
  final int number;
  final String text;
  final String translation;
  final int page;

  VerseModel({
    required this.page,
    required this.number,
    required this.text,
    required this.translation,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      number: json['number'],
      text: json['text'],
      translation: '',
      page: json['page'],
    );
  }

  VerseEntity toEntity() {
    return VerseEntity(
      number: number,
      page: page,
      text: text,
      translation: translation,
    );
  }
}
