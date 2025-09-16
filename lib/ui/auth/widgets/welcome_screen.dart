import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/images.dart';
import 'package:mobile_app/ui/core/ui/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.background,
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(100),
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLarge * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset(AppImages.logo, width: 200),
                const SizedBox(height: AppSizes.spacingLarge),
                Text(
                  'Greenhouse',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(flex: 3),
                CustomButton.text(
                  onTap: () => context.push(AppRoutes.login),
                  text: 'Continuar',
                  variant: ButtonVariant.accent,
                ),
                const SizedBox(height: AppSizes.spacingLarge * 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
