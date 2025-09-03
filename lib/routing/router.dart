import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/auth/widgets/login_screen.dart';
import 'package:mobile_app/ui/auth/widgets/welcome_screen.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/crop_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crop_details_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crops_screen.dart';
import 'package:mobile_app/ui/home/widgets/home_screen.dart';
import 'package:mobile_app/ui/stepper/widgets/create_crop_screen.dart';

/// La clase de configuración del enrutador principal para la aplicación.
///
/// Utiliza GoRouter para gestionar la navegación y aplica una lógica de redirección
/// basada en el estado de autenticación del usuario.
class AppRouter {
  AppRouter({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  static const Set<String> _publicPaths = {
    AppRoutes.welcome,
    AppRoutes.login,
  };

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.welcome,
    refreshListenable: _authRepository,
    routes: _routes,
    redirect: _redirect,
  );

  static final List<RouteBase> _routes = <RouteBase>[
    GoRoute(
      name: 'welcome',
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: 'login',
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'home',
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'create-crop',
      path: AppRoutes.createCrop,
      builder: (context, state) {
        final growRoomId = int.parse(state.pathParameters['growRoomId']!);
        return CreateCropScreen(growRoomId: growRoomId);
      },
    ),
    GoRoute(
      name: 'active-crop',
      path: AppRoutes.activeCrop,
      builder: (context, state) {
        final cropId = int.parse(state.pathParameters['cropId']!);
        final extra = state.extra as Map<String, dynamic>?;
        final growRoomName =
            extra?['growRoomName'] as String? ?? 'Cultivo Activo';
        return CropScreen(
          cropId: cropId,
          growRoomName: growRoomName,
        );
      },
    ),
    GoRoute(
      name: 'finished-crops',
      path: '${AppRoutes.archive}/:growRoomId',
      builder: (context, state) {
        final growRoomId = int.parse(state.pathParameters['growRoomId']!);
        return FinishedCropsScreen(growRoomId: growRoomId);
      },
    ),
    GoRoute(
        name: 'finished-crop-details',
        path: '${AppRoutes.archive}/:growRoomId/crop/:cropId',
        builder: (context, state) {
          final cropId = int.parse(state.pathParameters['cropId']!);
          final extra = state.extra as Map<String, dynamic>?;
          final totalProduction = extra?['totalProduction'] as String? ?? 'N/A';
          return FinishedCropDetailsScreenWrapper(
            cropId: cropId,
            totalProduction: totalProduction,
          );
        })
  ];

  FutureOr<String?> _redirect(BuildContext context, GoRouterState state) async {
    if (!_authRepository.isInitialized) return null;

    final bool isLoggedIn = _authRepository.isAuthenticated;
    final String path = state.matchedLocation;
    final bool isPublic = _publicPaths.contains(path);

    if (isLoggedIn && isPublic) return AppRoutes.home;
    if (!isLoggedIn && !isPublic) return AppRoutes.welcome;

    return null;
  }
}
