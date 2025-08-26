import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/auth/widgets/login_screen.dart';
import 'package:mobile_app/ui/auth/widgets/start_screen.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/crop/ui/stepper.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/create_crop_screen.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/crop_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crop_details_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crops_screen.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/home/widgets/home_screen.dart';
import 'package:mobile_app/ui/notifications/widgets/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.welcome,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: _redirect,
    refreshListenable: authRepository,
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(locator<SignInUseCase>()),
          child: const LoginScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BaseLayout(child: navigationShell);
        },
        branches: [
          // Pestaña 0: Naves de Cultivo Activas
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home, // Ruta '/'
                builder: (context, state) => ChangeNotifierProvider(
                  // Usamos un ViewModel dedicado solo para esta pantalla.
                  create: (_) => ActiveGrowRoomsViewModel(
                      locator()), // Asumimos GetActiveGrowRoomsUseCase
                  child: const ActiveGrowRoomsScreen(),
                ),
              ),
            ],
          ),

          // Pestaña 1: Archivo de Cultivos Terminados
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.archive, // Ruta '/archive'
                builder: (context, state) {
                  // === ESTA ES LA LÓGICA QUE COMPLETA TU COMENTARIO ===
                  // Se provee un ViewModel específico para la pantalla de archivo,
                  // que obtiene sus propias dependencias del locator.
                  return ChangeNotifierProvider(
                    create: (_) => ArchiveViewModel(
                        locator()), // Asumimos GetArchivedGrowRoomsUseCase
                    child: const ArchiveScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // --- Rutas que se muestran POR ENCIMA del Shell ---
      // Usan `parentNavigatorKey` para asegurar que se muestren a pantalla completa
      // y no dentro del layout del ShellRoute.
      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => NotificationScreen(),
      ),
      GoRoute(
        // NOTA: Usamos los helpers de tu `routes.dart` para construir las rutas
        // con los parámetros en el formato correcto que GoRouter espera.
        path: '/active-crops/:growRoomId/create-crop',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final growRoomId = int.parse(state.pathParameters['growRoomId']!);
          return ChangeNotifierProvider(
            create: (_) => CreateCropViewModel(
                growRoomId, locator()), // Asumimos CreateCropUseCase
            child: const CreateCropScreen(),
          );
        },
      ),
      GoRoute(
        path: '/active-crops/:growRoomId/crop/:cropId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final cropId = int.parse(state.pathParameters['cropId']!);
          return ChangeNotifierProvider(
            create: (_) => ActiveCropViewModel(
                cropId, locator(), locator()), // Asumimos use cases
            child: const CropScreen(),
          );
        },
      ),
      GoRoute(
        path: '/archive/:growRoomId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final growRoomId = int.parse(state.pathParameters['growRoomId']!);
          return ChangeNotifierProvider(
            create: (_) => FinishedCropsViewModel(growRoomId, locator()),
            child: const FinishedCropsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/archive/:growRoomId/crop/:cropId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final cropId = int.parse(state.pathParameters['cropId']!);
          return ChangeNotifierProvider(
            create: (_) => FinishedCropDetailViewModel(cropId, locator()),
            child: const FinishedCropDetailsScreen(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Error: Ruta no encontrada - ${state.error}')),
    ),
  );
}

class AppRouter {
  final AuthRepository authRepository;
  late final GoRouter router;

  AppRouter(this.authRepository) {
    router = GoRouter(
      initialLocation: Routes.welcome,
      refreshListenable: authRepository,
      redirect: _handleRedirect,
      routes: _appRoutes,
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Página no encontrada: ${state.error}'),
        ),
      ),
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    if (!authRepository.isInitialized) {
      return null;
    }

    final isAuthenticated = authRepository.isAuthenticated;
    final isAuthRoute = state.matchedLocation == Routes.login ||
        state.matchedLocation == Routes.start;

    if (!isAuthenticated && !isAuthRoute) {
      return Routes.start;
    }

    if (isAuthenticated && isAuthRoute) {
      return Routes.home;
    }

    return null;
  }

  List<RouteBase> get _appRoutes => [
        GoRoute(
          path: Routes.welcome,
          pageBuilder: (context, state) =>
              _buildPage(state, const StartScreen()),
        ),
        GoRoute(
          path: Routes.login,
          pageBuilder: (context, state) => _buildPage(
            state,
            ChangeNotifierProvider(
              create: (_) => locator<LoginViewModel>(),
              child: const LoginScreen(),
            ),
          ),
        ),
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            final viewModel = locator<HomeViewModel>();
            viewModel.hasNotification = true; // Example logic
            viewModel.onNotificationTap =
                () => context.push(Routes.notifications);

            return _buildPage(
              state,
              ChangeNotifierProvider.value(
                value: viewModel,
                child: BaseLayout(
                  title: Text('Bienvenido a Greenhouse',
                      style: Theme.of(context).textTheme.displaySmall),
                  actions: [
                    Builder(
                      builder: (innerContext) {
                        return IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Cerrar Sesión',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: innerContext,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Cerrar Sesión'),
                                content: const Text(
                                    '¿Estás seguro de que quieres cerrar sesión?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm ?? false) {
                              viewModel.signOut();
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: viewModel.handleNotificationTap,
                      child: NotificationIcon(
                          icon: AppIcons.bell,
                          hasNotification: viewModel.hasNotification),
                    ),
                    const SizedBox(width: 16),
                  ],
                  body: const HomeScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.notifications,
          pageBuilder: (context, state) => _buildPage(
            state,
            BaseLayout(
              title: Text('Notificaciones',
                  style: Theme.of(context).textTheme.displaySmall),
              showBackButton: true,
              body: const NotificationScreen(),
            ),
          ),
        ),
        GoRoute(
          name: 'crop',
          path: Routes.crop,
          pageBuilder: (context, state) {
            final cropId = int.parse(state.pathParameters['cropId']!);
            final growRoomName = state.extra as String? ?? 'Nave de Cultivo';

            return _buildPage(
              state,
              ChangeNotifierProvider(
                create: (_) => locator<ActiveCropViewModel>(param1: cropId),
                child: BaseLayout(
                  title: Text(growRoomName,
                      style: Theme.of(context).textTheme.displaySmall),
                  body: Consumer<ActiveCropViewModel>(
                      builder: (context, viewModel, _) =>
                          CropScreen(viewModel: viewModel)),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.createCrop,
          pageBuilder: (context, state) {
            final growRoomId = int.parse(state.pathParameters['growRoomId']!);
            final viewModel = locator<CreateCropViewModel>(param1: growRoomId);

            return _buildPage(
              state,
              ChangeNotifierProvider.value(
                value: viewModel,
                child: PopScope(
                  canPop: viewModel.currentStep == 0,
                  onPopInvoked: (didPop) {
                    if (!didPop) viewModel.previousStep(context);
                  },
                  child: BaseLayout(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => viewModel.previousStep(context),
                    ),
                    title: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) => CustomStepper(
                          steps: viewModel.steps,
                          onStepTapped: viewModel.goToStep),
                    ),
                    body: CreateCropScreen(viewModel: viewModel),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.finishedCrops,
          pageBuilder: (context, state) {
            final growRoomId = int.parse(state.pathParameters['growRoomId']!);

            return _buildPage(
              state,
              ChangeNotifierProvider(
                create: (_) =>
                    locator<FinishedCropsViewModel>(param1: growRoomId),
                child: BaseLayout(
                  title: Text('Cultivos Finalizados',
                      style: Theme.of(context).textTheme.displaySmall),
                  showBackButton: true,
                  body: Consumer<FinishedCropsViewModel>(
                    builder: (context, viewModel, _) =>
                        FinishedCropsScreen(viewModel: viewModel),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.finishedCropDetail,
          pageBuilder: (context, state) {
            final cropId = int.parse(state.pathParameters['cropId']!);
            final totalProduction = state.extra as String? ?? 'N/A';

            return _buildPage(
              state,
              ChangeNotifierProvider(
                create: (_) =>
                    locator<FinishedCropDetailViewModel>(param1: cropId),
                child: BaseLayout(
                  title: Text('Cultivo #$cropId',
                      style: Theme.of(context).textTheme.displaySmall),
                  showBackButton: true,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Consumer<FinishedCropDetailViewModel>(
                      builder: (context, viewModel, _) =>
                          FinishedCropDetailsScreen(
                        viewModel: viewModel,
                        totalProduction: totalProduction,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ];

  CustomTransitionPage<T> _buildPage<T>(GoRouterState state, Widget child) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child, // Sin animación
    );
  }
}

// ---- Helper Widgets (para mantener el archivo autocontenido) ----

class NotificationIcon extends StatelessWidget {
  const NotificationIcon(
      {super.key, required this.icon, required this.hasNotification});
  final String icon;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.0,
      height: 32.0,
      child: Stack(
        children: [
          SvgPicture.asset(
            icon,
            width: 32.0,
            height: 32.0,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
          ),
          if (hasNotification)
            Positioned(
              top: 0,
              right: 0,
              child: RedDot(),
            ),
        ],
      ),
    );
  }
}

class RedDot extends StatelessWidget {
  const RedDot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        border:
            Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final isAuthenticated = await context.read<AuthRepository>().isAuthenticated;
  final isAuthRoute = state.matchedLocation == Routes.login;
  if (!isAuthenticated) {
    return Routes.welcome;
  }

  if (isAuthRoute) {
    return Routes.home;
  }

  return null;
}
