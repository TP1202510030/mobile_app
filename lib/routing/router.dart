import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/notifications/widgets/notifications_screen.dart';

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
    },
  );
}

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            final viewModel = HomeViewModel();
            viewModel.hasNotification =
                true; // To be replaced with actual logic
            viewModel.onNotificationTap = () {
              context.push(Routes.notifications);
            };

            return buildPageWithoutAnimation<void>(
              context: context,
              state: state,
              child: BaseLayout(
                title: 'Bienvenido a Greenhouse',
                actions: [
                  InkWell(
                    onTap: viewModel.handleNotificationTap,
                    child: NotificationIcon(
                      icon: AppIcons.bell,
                      hasNotification: viewModel.hasNotification,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                body: HomeScreen(viewModel: viewModel),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.notifications,
          pageBuilder: (context, state) {
            return buildPageWithoutAnimation<void>(
              context: context,
              state: state,
              child: const BaseLayout(
                title: 'Notificaciones',
                showBackButton: true,
                body: NotificationScreen(),
              ),
            );
          },
        ),
      ],
    );
