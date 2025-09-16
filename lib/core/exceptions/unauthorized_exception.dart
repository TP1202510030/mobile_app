import 'package:mobile_app/core/exceptions/api_exception.dart';

class UnauthorizedException extends ApiException {
  UnauthorizedException(
      {super.message = 'Session expired. Please log in again.'})
      : super(statusCode: 401);
}
