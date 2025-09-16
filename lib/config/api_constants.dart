/// A collection of constants related to the API configuration.
///
/// This abstract final class provides values for default pagination,
/// API timeouts, and environment variable keys.
abstract final class ApiConstants {
  // Pagination
  static const int defaultPage = 0;
  static const int defaultPageSize = 20;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Environment Variable Keys
  static const String baseUrlKey = 'BASE_URL';
  static const String defaultBaseUrl = 'http://localhost:3000/api/v1';
}
