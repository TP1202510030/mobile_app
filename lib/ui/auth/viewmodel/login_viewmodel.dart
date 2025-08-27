import 'package:flutter/material.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/utils/command.dart';
import 'package:mobile_app/utils/result.dart';

class LoginViewModel {
  final SignInUseCase _signInUseCase;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  late final Command<void, SignInParams> signInCommand;

  final ValueNotifier<bool> isPasswordVisibleNotifier = ValueNotifier(false);

  final ValueNotifier<bool> isFormValidNotifier = ValueNotifier(false);

  LoginViewModel(this._signInUseCase) {
    signInCommand = Command(_signIn);
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  Future<Result<void>> _signIn(SignInParams params) {
    return _signInUseCase(params);
  }

  void togglePasswordVisibility() {
    isPasswordVisibleNotifier.value = !isPasswordVisibleNotifier.value;
  }

  void _validateForm() {
    final isValid = usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    if (isFormValidNotifier.value != isValid) {
      isFormValidNotifier.value = isValid;
    }
  }

  void dispose() {
    usernameController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    usernameController.dispose();
    passwordController.dispose();
    signInCommand.dispose();
    isPasswordVisibleNotifier.dispose();
    isFormValidNotifier.dispose();
  }
}
