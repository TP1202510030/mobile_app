import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_app/data/repositories/auth_repository_impl.dart';
import 'package:mobile_app/data/repositories/control_action_repository_impl.dart';
import 'package:mobile_app/data/repositories/crop_repository_impl.dart';
import 'package:mobile_app/data/repositories/grow_room_repository_impl.dart';
import 'package:mobile_app/data/repositories/measurement_repository_impl.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/data/services/api/control_action_service.dart';
import 'package:mobile_app/data/services/api/crop_service.dart';
import 'package:mobile_app/data/services/api/grow_room_service.dart';
import 'package:mobile_app/data/services/api/measurement_service.dart';
import 'package:mobile_app/data/services/api/auth_service.dart';
import 'package:mobile_app/domain/mappers/create_crop_mapper.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/crop/advance_crop_phase_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/create_crop_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/finish_crop_use_case.dart';
import 'package:mobile_app/domain/use_cases/control_action/get_control_actions_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_crop_details_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crop_details_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crops_by_grow_room_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crops_data_use_case.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_room_by_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_rooms_by_company_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/measurement/get_measurements_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:mobile_app/domain/validators/create_crop_validator.dart';
import 'package:mobile_app/ui/auth/viewmodel/login_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // --- SINGLETONS ---

  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton(sharedPreferences);
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton(() => const FlutterSecureStorage());

  // Core Layer (API)
  locator.registerLazySingleton(() => ApiClient(locator(), locator()));

  locator.registerLazySingleton(() => AuthService(locator(), locator()));
  locator.registerLazySingleton(() => GrowRoomService(locator()));
  locator.registerLazySingleton(() => CropService(locator()));
  locator.registerLazySingleton(() => MeasurementService(locator()));
  locator.registerLazySingleton(() => ControlActionService(locator()));

  // Data Layer (Repositories)
  locator.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(locator(), locator()));

  locator.registerLazySingleton<GrowRoomRepository>(
      () => GrowRoomRepositoryImpl(locator()));

  locator.registerLazySingleton<CropRepository>(
      () => CropRepositoryImpl(locator()));

  locator.registerLazySingleton<MeasurementRepository>(
      () => MeasurementRepositoryImpl(locator()));

  locator.registerLazySingleton<ControlActionRepository>(
      () => ControlActionRepositoryImpl(locator()));

  // Domain Layer (Use Cases)
  // Auth
  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUseCase(locator()));

  // GrowRoom
  locator
      .registerLazySingleton(() => GetGrowRoomsByCompanyIdUseCase(locator()));
  locator.registerLazySingleton(() => GetGrowRoomByIdUseCase(locator()));

  // Crop
  locator.registerLazySingleton(() => CreateCropUseCase(locator()));
  locator.registerLazySingleton(
      () => GetCropDetailsUseCase(locator(), locator(), locator(), locator()));
  locator.registerLazySingleton(() => AdvanceCropPhaseUseCase(locator()));
  locator.registerLazySingleton(() => FinishCropUseCase(locator()));
  locator.registerLazySingleton(
      () => GetFinishedCropsByGrowRoomIdUseCase(locator()));
  locator.registerLazySingleton(
      () => GetFinishedCropDetailsUseCase(locator(), locator(), locator()));
  locator.registerLazySingleton(
      () => GetFinishedCropsDataUseCase(locator(), locator()));

  locator.registerLazySingleton(() => CreateCropValidator());
  locator.registerLazySingleton(() => CreateCropMapper());

  // Measurement
  locator
      .registerLazySingleton(() => GetMeasurementsByPhaseIdUseCase(locator()));

  // ControlAction
  locator.registerLazySingleton(
      () => GetControlActionsByPhaseIdUseCase(locator()));

  // --- FACTORIES (ViewModels) ---
  locator.registerFactory(() => LoginViewModel(locator()));
  locator.registerLazySingleton(() => HomeViewModel(locator()));

  locator.registerFactoryParam<CreateCropViewModel, int, void>(
      (growRoomId, _) =>
          CreateCropViewModel(growRoomId, locator(), locator(), locator()));

  locator.registerFactoryParam<ActiveCropViewModel, int, void>(
    (cropId, _) => ActiveCropViewModel(
      cropId: cropId,
      getCropDetailsUseCase: locator(),
      getMeasurementsUseCase: locator(),
      getControlActionsUseCase: locator(),
      advanceCropPhaseUseCase: locator(),
      finishCropUseCase: locator(),
    ),
  );

  locator.registerFactoryParam<FinishedCropsViewModel, int, void>(
    (growRoomId, _) => FinishedCropsViewModel(
      growRoomId: growRoomId,
      getFinishedCropsDataUseCase: locator(),
    ),
  );

  locator.registerFactoryParam<FinishedCropDetailViewModel, int, void>(
    (cropId, _) => FinishedCropDetailViewModel(
      cropId: cropId,
      getFinishedCropDetailsUseCase: locator(),
    ),
  );
}
