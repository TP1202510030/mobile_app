import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/images.dart';
import 'package:mobile_app/ui/core/ui/back_button.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/core/exceptions/unauthorized_exception.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<LoginViewModel>(
      create: (_) => locator<LoginViewModel>(),
      dispose: (_, viewModel) => viewModel.dispose(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();

  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoginViewModel>();
    _viewModel.signInCommand.addListener(_onSignInResult);
  }

  @override
  void dispose() {
    _viewModel.signInCommand.removeListener(_onSignInResult);
    super.dispose();
  }

  void _onSignInResult() {
    if (!mounted) return;
    final signInCommand = _viewModel.signInCommand;
    if (signInCommand.isSuccess) {
      context.go(AppRoutes.home);
    } else if (signInCommand.hasError) {
      final message = _customErrorMessage(signInCommand.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _customErrorMessage(Exception? e) {
    if (e == null) return 'Ocurrió un error inesperado.';
    if (e is UnauthorizedException) {
      return 'Usuario o contraseña incorrectos.';
    }
    if (e is ApiException) {
      return e.message;
    }
    return 'No se pudo iniciar sesión. Intenta nuevamente.';
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _viewModel.signInCommand.execute(SignInParams(
      username: _viewModel.usernameController.text.trim(),
      password: _viewModel.passwordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          const _BackgroundHeader(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.spacingLarge),
                  CustomBackButton(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Inicia sesión',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              Text(
                                'Bienvenido a Greenhouse',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: AppSizes.spacingMedium),
                              Text('Inicia sesión en tu cuenta',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: AppSizes.spacingLarge * 2),
                              _UsernameField(viewModel: _viewModel),
                              const SizedBox(height: AppSizes.spacingLarge),
                              _PasswordField(viewModel: _viewModel),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _LoginButton(onPressed: _submit),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom +
                        AppSizes.spacingMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundHeader extends StatelessWidget {
  const _BackgroundHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 280,
      width: double.infinity,
      child: Image(
        image: AssetImage(AppImages.loginClipper),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final LoginViewModel viewModel;
  const _UsernameField({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: viewModel.usernameController,
      decoration: const InputDecoration(labelText: 'Nombre de usuario'),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return 'Ingresa tu usuario';
        return null;
      },
      inputFormatters: const [],
      enableSuggestions: true,
      autocorrect: true,
    );
  }
}

class _PasswordField extends StatelessWidget {
  final LoginViewModel viewModel;
  const _PasswordField({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.isPasswordVisibleNotifier,
      builder: (context, isVisible, _) {
        return TextFormField(
          controller: viewModel.passwordController,
          obscureText: !isVisible,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          autofillHints: const [AutofillHints.password],
          enableSuggestions: false,
          autocorrect: false,
          validator: (value) {
            final v = value ?? '';
            if (v.isEmpty) return 'Ingresa tu contraseña';
            return null;
          },
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();
    return ListenableBuilder(
      listenable: Listenable.merge([
        viewModel.isFormValidNotifier,
        viewModel.signInCommand,
      ]),
      builder: (context, _) {
        final isFormValid = viewModel.isFormValidNotifier.value;
        final isLoading = viewModel.signInCommand.isRunning;
        return CustomButton.text(
          onTap: isFormValid && !isLoading ? onPressed : null,
          text: 'Iniciar sesión',
          isLoading: isLoading,
          isFullWidth: true,
          variant: ButtonVariant.primary,
        );
      },
    );
  }
}
