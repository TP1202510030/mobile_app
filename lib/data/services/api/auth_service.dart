import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/api_routes.dart';
import 'package:mobile_app/config/storage_constants.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/domain/entities/iam/authenticated_user.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';

/// Service for handling authentication-related API calls.
class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = StorageConstants.authTokenKey;

  AuthService(this._apiClient, this._secureStorage);

  Future<AuthenticatedUser> signIn(String username, String password) async {
    final url = ApiRoutes.signIn;

    try {
      final response = await _apiClient.post(
        url,
        data: {'username': username, 'password': password},
      );

      final user = AuthenticatedUser.fromJson(response.data);
      await _secureStorage.write(key: _tokenKey, value: user.token);
      return user;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: 'An unknown error occurred during sign-in.');
    }
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: _tokenKey);
    // Aquí podrías llamar a un endpoint de /sign-out si existiera.
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null;
  }
}
