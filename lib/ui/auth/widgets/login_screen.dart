import 'package:flutter/material.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset(
                'assets/images/background_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Inicia sesión',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Bienvenido a Greenhouse',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inicia sesión en tu cuenta',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: viewModel.emailController,
                              decoration: const InputDecoration(
                                  labelText: 'Nombre de usuario'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: viewModel.passwordController,
                              obscureText: !viewModel.isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    viewModel.isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: viewModel.togglePasswordVisibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (viewModel.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              CustomButton(
                                onTap: viewModel.signIn,
                                child: Text(
                                  'Iniciar sesión',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            if (viewModel.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
