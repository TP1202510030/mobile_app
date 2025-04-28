import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:mobile_app/ui/auth/login/widgets/login_screen.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

import '../ui/home/widgets/home_screen.dart';
import 'routes.dart';

CustomTransitionPage<T> buildPageWithoutAnimation<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      });
}

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            final viewModel = HomeViewModel();
            return buildPageWithoutAnimation<void>(
              context: context,
              state: state,
              child: HomeScreen(viewModel: viewModel),
            );
          },
        ),
        GoRoute(
          path: Routes.login,
          pageBuilder: (context, state) {
            final viewModel = LoginViewModel();
            return buildPageWithoutAnimation(
              context: context,
              state: state,
              child: LoginScreen(viewModel: viewModel),
            );
          },
        ),
      ],
    );
