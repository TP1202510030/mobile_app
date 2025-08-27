import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/images.dart';
import 'package:mobile_app/ui/core/ui/back_button.dart';
import 'package:mobile_app/ui/core/ui/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<LoginViewModel>();
    _viewModel.signInCommand.addListener(_onSignInResult);
  }

  @override
  void dispose() {
    _viewModel.signInCommand.removeListener(_onSignInResult);
    _viewModel.dispose();
    super.dispose();
  }

  void _onSignInResult() {
    if (!mounted) return;

    if (_viewModel.signInCommand.isSuccess) {
      context.go(AppRoutes.home);
    } else if (_viewModel.signInCommand.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.signInCommand.error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      _viewModel.signInCommand.reset();
    }
  }

  void _performLogin() {
    FocusScope.of(context).unfocus();
    _viewModel.signInCommand.execute(SignInParams(
      username: _viewModel.usernameController.text.trim(),
      password: _viewModel.passwordController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          _buildBackgroundHeader(),
          _buildFormContent(),
        ],
      ),
    );
  }

  /// Construye la cabecera usando la imagen pre-cortada.
  Widget _buildBackgroundHeader() {
    return const SizedBox(
      height: 280, // Mantenemos una altura consistente
      width: double.infinity,
      child: Image(
        image: AssetImage(AppImages.loginClipper),
        fit: BoxFit.cover, // Asegura que la imagen cubra el área
      ),
    );
  }

  /// Construye todo el contenido que va por encima del fondo.
  Widget _buildFormContent() {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingLarge * 1.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.padding.top + AppSizes.spacingSmall),
            CustomBackButton(
              color: theme.colorScheme.onSecondary,
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Text(
              'Inicia sesión',
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150),
                    Text(
                      'Bienvenido a Greenhouse',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Text(
                      'Inicia sesión en tu cuenta',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSizes.spacingLarge * 2),
                    _buildLoginForm(),
                  ],
                ),
              ),
            ),
            _buildLoginButton(),
            SizedBox(
                height: mediaQuery.padding.bottom + AppSizes.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _viewModel.usernameController,
          decoration: const InputDecoration(labelText: 'Nombre de usuario'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSizes.spacingLarge),
        ValueListenableBuilder<bool>(
          valueListenable: _viewModel.isPasswordVisibleNotifier,
          builder: (context, isVisible, child) {
            return TextFormField(
              controller: _viewModel.passwordController,
              obscureText: !isVisible,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _viewModel.togglePasswordVisibility,
                ),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_viewModel.isFormValidNotifier.value) {
                  _performLogin();
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _viewModel.isFormValidNotifier,
        _viewModel.signInCommand,
      ]),
      builder: (context, child) {
        final isFormValid = _viewModel.isFormValidNotifier.value;
        final isLoading = _viewModel.signInCommand.isRunning;

        return CustomButton.text(
          onTap: isFormValid && !isLoading ? _performLogin : null,
          text: 'Iniciar sesión',
          isLoading: isLoading,
          isFullWidth: true,
          variant: ButtonVariant.primary,
        );
      },
    );
  }
}
