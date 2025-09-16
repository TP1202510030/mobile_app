/// A collection of constants for secure storage keys.
///
/// This abstract final class prevents the use of magic strings when interacting
/// with FlutterSecureStorage, improving maintainability.
abstract final class StorageConstants {
  static const String authTokenKey = 'auth_token';
  static const String companyIdKey = 'company_id';
}
