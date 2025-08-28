import 'package:flutter/material.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/utils/command.dart';
import 'package:mobile_app/utils/result.dart';

class LoginViewModel {
  final SignInUseCase _signInUseCase;

  LoginViewModel(this._signInUseCase) {
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    signInCommand = Command<void, SignInParams>(_executeSignIn);
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final Command<void, SignInParams> signInCommand;

  final ValueNotifier<bool> isPasswordVisibleNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isFormValidNotifier = ValueNotifier(false);

  void togglePasswordVisibility() {
    isPasswordVisibleNotifier.value = !isPasswordVisibleNotifier.value;
  }

  Future<Result<void>> _executeSignIn(SignInParams params) async {
    return await _signInUseCase(params);
  }

  void _validateForm() {
    final String user = usernameController.text.trim();
    final String pass = passwordController.text;
    final bool valid = user.isNotEmpty && pass.length >= 3;
    if (isFormValidNotifier.value != valid) {
      isFormValidNotifier.value = valid;
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
