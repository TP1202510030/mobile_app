import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/archive/widgets/archive_screen.dart';
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
            return buildPageWithoutAnimation<void>(
              context: context,
              state: state,
              child: BaseLayout(
                body: HomeScreen(viewModel: HomeViewModel()),
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
                body: NotificationScreen(),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.cropsArchive,
          pageBuilder: (context, state) {
            return buildPageWithoutAnimation<void>(
              context: context,
              state: state,
              child: const BaseLayout(
                body: CropsArchiveScreen(),
              ),
            );
          },
        ),
      ],
    );
