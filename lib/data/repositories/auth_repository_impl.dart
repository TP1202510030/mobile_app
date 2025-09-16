import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/storage_constants.dart';
import 'package:mobile_app/data/services/api/auth_service.dart';
import 'package:mobile_app/domain/entities/iam/authenticated_user.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/utils/result.dart';

/// Concrete implementation of [AuthRepository].
class AuthRepositoryImpl extends ChangeNotifier implements AuthRepository {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;

  static const _authTokenKey = StorageConstants.authTokenKey;
  static const _companyIdKey = StorageConstants.companyIdKey;

  bool _isAuthenticated = false;
  bool _isInitialized = false;
  int? _companyId;

  AuthRepositoryImpl(this._authService, this._secureStorage);

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isInitialized => _isInitialized;

  @override
  int? get companyId => _companyId;

  @override
  Future<void> initialize() async {
    final token = await _secureStorage.read(key: _authTokenKey);
    final companyIdStr = await _secureStorage.read(key: _companyIdKey);

    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      if (companyIdStr != null) {
        _companyId = int.tryParse(companyIdStr);
      }
    } else {
      _isAuthenticated = false;
      _companyId = null;
    }

    _isInitialized = true;
    notifyListeners();
  }

  @override
  Future<Result<void>> signIn(
      {required String username, required String password}) async {
    try {
      final user = await _authService.signIn(username, password);
      await _saveAuthData(user);

      _isAuthenticated = true;
      _companyId = user.companyId;
      notifyListeners();

      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authService.signOut();
      await _clearAuthData();

      _isAuthenticated = false;
      _companyId = null;
      notifyListeners();
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception("Failed to clear local auth data."));
    }
  }

  @override
  Future<String?> getToken() => _secureStorage.read(key: _authTokenKey);

  Future<void> _saveAuthData(AuthenticatedUser user) async {
    await _secureStorage.write(key: _authTokenKey, value: user.token);
    await _secureStorage.write(
        key: _companyIdKey, value: user.companyId.toString());
  }

  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: _authTokenKey);
    await _secureStorage.delete(key: _companyIdKey);
  }
}
