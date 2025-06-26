import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  }
}
