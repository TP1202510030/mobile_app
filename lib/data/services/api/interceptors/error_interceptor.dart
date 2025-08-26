import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/core/exceptions/network_exception.dart';
import 'package:mobile_app/core/exceptions/unauthorized_exception.dart';

class ErrorInterceptor extends Interceptor {
  final _logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'Dio Error!',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    final exception = _handleDioError(err);
    super.onError(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
      handler,
    );
  }

  ApiException _handleDioError(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.cancel) {
      return NetworkException(message: 'Connection timeout.');
    }

    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      if (statusCode == 401) {
        return UnauthorizedException();
      }

      return ApiException(
        message: err.response?.data?['message'] ?? 'A server error occurred.',
        statusCode: statusCode,
      );
    }

    if (err.error is SocketException) {
      return NetworkException();
    }

    return ApiException(message: 'An unexpected error occurred.');
  }
}
