import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/data/repositories/auth_repository.dart';
import 'package:mobile_app/data/services/api/model/grow_room/control_action_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/crop_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/grow_room_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/measurement_service.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';

import 'package:mobile_app/ui/crop/ui/stepper.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/create_crop_screen.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/crop_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crop_details_screen.dart';
import 'package:mobile_app/ui/crop/widgets/finished_crop_screen/finished_crops_screen.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/notifications/widgets/notifications_screen.dart';
import 'package:mobile_app/ui/home/widgets/home_screen.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/auth/widgets/login_screen.dart';
import 'package:mobile_app/ui/auth/widgets/start_screen.dart';
import 'package:provider/provider.dart';
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

GoRouter router(AuthRepository authRepository) {
  final apiBaseUrl = dotenv.env['BASE_URL']!;

  return GoRouter(
    initialLocation: Routes.start,
    refreshListenable: authRepository,
    redirect: (BuildContext context, GoRouterState state) {
      if (!authRepository.isInitialized) {
        return null;
      }

      final isAuthenticated = authRepository.isAuthenticated;
      final isLoggingIn = state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.start;

      if (!isAuthenticated && !isLoggingIn) {
        return Routes.start;
      }

      if (isAuthenticated && isLoggingIn) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.start,
        pageBuilder: (context, state) => buildPageWithoutAnimation(
          context: context,
          state: state,
          child: const StartScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: ChangeNotifierProvider(
              create: (_) => LoginViewModel(authRepository),
              child: const LoginScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) {
          final viewModel = HomeViewModel(
            GrowRoomService(baseUrl: apiBaseUrl),
          );
          viewModel.hasNotification = true;
          viewModel.onNotificationTap = () {
            context.push(Routes.notifications);
          };

          return buildPageWithoutAnimation<void>(
            context: context,
            state: state,
            child: BaseLayout(
              title: Text(
                'Bienvenido a Greenhouse',
                style: Theme.of(context).textTheme.displaySmall,
              ),
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
            child: BaseLayout(
              title: Text(
                'Notificaciones',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              showBackButton: true,
              body: const NotificationScreen(),
            ),
          );
        },
      ),
      GoRoute(
        name: 'crop',
        path: Routes.crop,
        pageBuilder: (context, state) {
          final cropIdString = state.pathParameters['cropId']!;
          final cropId = int.parse(cropIdString);
          final String growRoomName =
              state.extra as String? ?? 'Nave de Cultivo';

          final measurementService = MeasurementService(baseUrl: apiBaseUrl);
          final controlActionService =
              ControlActionService(baseUrl: apiBaseUrl);
          final cropService = CropService(baseUrl: apiBaseUrl);

          final viewModel = ActiveCropViewModel(
            cropId,
            cropService,
            measurementService,
            controlActionService,
          );

          return buildPageWithoutAnimation<void>(
            context: context,
            state: state,
            child: BaseLayout(
              title: Text(
                growRoomName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              body: CropScreen(viewModel: viewModel),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.createCrop,
        pageBuilder: (context, state) {
          final growRoomIdString = state.pathParameters['growRoomId']!;
          final growRoomId = int.parse(growRoomIdString);

          final cropService = CropService(baseUrl: apiBaseUrl);
          final viewModel = CreateCropViewModel(growRoomId, cropService);

          return buildPageWithoutAnimation<void>(
            context: context,
            state: state,
            child: PopScope(
              canPop: viewModel.currentStep == 0,
              onPopInvokedWithResult: (bool didPop, dynamic _) {
                if (!didPop) {
                  viewModel.previousStep(context);
                }
              },
              child: BaseLayout(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    viewModel.previousStep(context);
                  },
                ),
                title: ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, child) {
                    return CustomStepper(
                      steps: viewModel.steps,
                      onStepTapped: viewModel.goToStep,
                    );
                  },
                ),
                body: CreateCropScreen(viewModel: viewModel),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.finishedCrops,
        pageBuilder: (context, state) {
          final growRoomId = int.parse(state.pathParameters['growRoomId']!);

          final viewModel = FinishedCropsViewModel(
            growRoomId: growRoomId,
            cropService: CropService(baseUrl: apiBaseUrl),
            growRoomService: GrowRoomService(baseUrl: apiBaseUrl),
          );

          return buildPageWithoutAnimation<void>(
            context: context,
            state: state,
            child: BaseLayout(
              title: Text(
                'Cultivos Finalizados',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              showBackButton: true,
              body: FinishedCropsScreen(viewModel: viewModel),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.finishedCropDetail,
        pageBuilder: (context, state) {
          final cropId = int.parse(state.pathParameters['cropId']!);
          final totalProduction = state.extra as String? ?? 'N/A';

          final viewModel = FinishedCropDetailViewModel(
            cropId: cropId,
            cropService: CropService(baseUrl: apiBaseUrl),
          );

          return buildPageWithoutAnimation<void>(
            context: context,
            state: state,
            child: BaseLayout(
              title: Text(
                'Cultivo #$cropId',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              showBackButton: true,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FinishedCropDetailsScreen(
                  viewModel: viewModel,
                  totalProduction: totalProduction,
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
