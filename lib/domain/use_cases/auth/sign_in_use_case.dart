import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

/// Caso de Uso para manejar el inicio de sesión del usuario.
///
/// Encapsula la lógica de llamar al repositorio de autenticación para
/// que un usuario inicie sesión.
class SignInUseCase implements UseCase<Result<void>, SignInParams> {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  @override
  Future<Result<void>> call(SignInParams params) {
    return _authRepository.signIn(
      username: params.username,
      password: params.password,
    );
  }
}

/// Parámetros necesarios para el [SignInUseCase].
class SignInParams {
  final String username;
  final String password;

  SignInParams({required this.username, required this.password});
}
