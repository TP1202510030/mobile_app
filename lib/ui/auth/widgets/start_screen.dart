import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/ui/button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/images/background_image.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
          // Contenido centrado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Logo
                Image.asset('assets/images/logo.png', width: 200),
                const SizedBox(height: 16),
                // Texto
                Text(
                  'Greenhouse',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(flex: 3),
                // Botón
                CustomButton(
                  onTap: () => context.push(Routes.login),
                  child: Text(
                    'Continuar',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
