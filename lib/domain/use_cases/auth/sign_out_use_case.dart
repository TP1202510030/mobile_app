import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

/// Caso de Uso para manejar el cierre de sesión del usuario.
class SignOutUseCase implements UseCase<void, void> {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  @override
  Future<Result<void>> call(void params) {
    return _authRepository.signOut();
  }
}
