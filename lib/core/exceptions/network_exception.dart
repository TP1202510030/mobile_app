import 'package:mobile_app/core/exceptions/api_exception.dart';

class NetworkException extends ApiException {
  NetworkException(
      {super.message = 'No internet connection. Please check your network.'});
}
