import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/data/services/api/model/iam/auth_service.dart';

class AuthRepository extends ChangeNotifier {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  bool _isAuthenticated = false;
  bool _isInitialized = false;

  AuthRepository(this._authService) {
    _initialize();
  }

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  bool get isInitialized => _isInitialized;

  Future<void> _initialize() async {
    _token = await _storage.read(key: 'auth_token');
    _isAuthenticated = _token != null;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> signIn(String username, String password) async {
    final authenticatedUser = await _authService.signIn(username, password);
    _token = authenticatedUser.token;
    await _storage.write(key: 'auth_token', value: _token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }
}
