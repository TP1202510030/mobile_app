import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/config/app_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/data/services/api/interceptors/auth_interceptor.dart';
import 'package:mobile_app/data/services/api/interceptors/error_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static final String _baseUrl = AppConfig.baseUrl;

  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;

    _dio.interceptors.add(AuthInterceptor(_secureStorage));
    _dio.interceptors.add(ErrorInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> put<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.delete<T>(path, data: data, queryParameters: queryParameters);
  }
}
