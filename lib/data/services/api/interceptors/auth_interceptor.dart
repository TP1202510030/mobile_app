import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/config/storage_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final _logger = Logger();

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: StorageConstants.authTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      _logger.i('Token added to header');
    }
    super.onRequest(options, handler);
  }
}
