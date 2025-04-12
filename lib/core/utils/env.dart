import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.aladhan.com/v1';
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // App Configuration
  static String get defaultCity => dotenv.env['DEFAULT_CITY'] ?? 'Tunis';
  static int get defaultSurah =>
      int.tryParse(dotenv.env['DEFAULT_SURAH'] ?? '1') ?? 1;
  static int get defaultVerse =>
      int.tryParse(dotenv.env['DEFAULT_VERSE'] ?? '1') ?? 1;

  // Notification Configuration
  static String get notificationChannelId =>
      dotenv.env['NOTIFICATION_CHANNEL_ID'] ?? 'deeds_notifications';
  static String get notificationChannelName =>
      dotenv.env['NOTIFICATION_CHANNEL_NAME'] ?? 'Deeds Notifications';
  static String get notificationChannelDescription =>
      dotenv.env['NOTIFICATION_CHANNEL_DESCRIPTION'] ??
      'Notifications for prayer times and other reminders';

  // Chat API Configuration
  static String get huggingfaceApiUrl =>
      dotenv.env['HUGGINGFACE_API_URL'] ?? '';
  static String get huggingfaceApiKey =>
      dotenv.env['HUGGINGFACE_API_KEY'] ?? '';
  static String get openaiApiUrl => dotenv.env['OPENAI_API_URL'] ?? '';
  static String get openaiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get openaiModel =>
      dotenv.env['OPENAI_MODEL'] ?? 'gpt-3.5-turbo';
}
