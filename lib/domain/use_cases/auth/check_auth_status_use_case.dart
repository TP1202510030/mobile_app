import 'package:mobile_app/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _authRepository;

  CheckAuthStatusUseCase(this._authRepository);

  bool call() {
    return _authRepository.isAuthenticated;
  }
}
