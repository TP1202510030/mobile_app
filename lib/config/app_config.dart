import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/config/api_constants.dart';

class AppConfig {
  static String get baseUrl {
    return dotenv.env[ApiConstants.baseUrlKey] ?? ApiConstants.defaultBaseUrl;
  }
}
