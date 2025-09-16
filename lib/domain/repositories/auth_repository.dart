import 'package:flutter/foundation.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the authentication operations.
/// Extends [ChangeNotifier] so it can be used with Provider and listened to
/// by GoRouter for automatic redirections.
abstract class AuthRepository extends ChangeNotifier {
  /// Returns true when the user is authenticated.
  bool get isAuthenticated;

  /// Returns true once the repository has loaded the initial auth state from storage.
  bool get isInitialized;

  /// The company ID of the authenticated user.
  int? get companyId;

  /// Retrieves the stored authentication token.
  Future<String?> getToken();

  /// Loads the initial authentication state from secure storage.
  Future<void> initialize();

  /// Performs the sign-in operation.
  Future<Result<void>> signIn(
      {required String username, required String password});

  /// Performs the sign-out operation.
  Future<Result<void>> signOut();
}
