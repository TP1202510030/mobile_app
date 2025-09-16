import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_room_by_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetCropDetailsUseCase
    implements UseCase<Result<CropDetails>, GetCropDetailsParams> {
  final CropRepository _cropRepository;
  final MeasurementRepository _measurementRepository;
  final ControlActionRepository _controlActionRepository;
  final GetGrowRoomByIdUseCase _getGrowRoomByIdUseCase;

  GetCropDetailsUseCase(
    this._cropRepository,
    this._measurementRepository,
    this._controlActionRepository,
    this._getGrowRoomByIdUseCase,
  );

  @override
  Future<Result<CropDetails>> call(GetCropDetailsParams params) async {
    final cropResult = await _cropRepository.getCropById(params.cropId);

    return cropResult.when(
      success: (crop) async {
        final growRoomResult = await _getGrowRoomByIdUseCase(
            GetGrowRoomByIdParams(growRoomId: crop.growRoomId));

        if (growRoomResult is Error<GrowRoom>) {
          return Result.error(growRoomResult.error);
        }

        final growRoom = (growRoomResult as Success<GrowRoom>).value;

        if (crop.currentPhase == null) {
          return Result.success(CropDetails(
            crop: crop,
            measurements: [],
            controlActions: [],
            actuatorStates: growRoom.actuatorStates,
          ));
        }

        final measurementsFuture = _measurementRepository
            .getMeasurementsForCurrentPhaseByCropId(params.cropId);

        final controlActionsFuture =
            _controlActionRepository.getControlActionsForCurrentPhaseByCropId(
          params.cropId,
          ApiConstants.defaultPage,
          ApiConstants.defaultPageSize,
        );

        final results =
            await Future.wait([measurementsFuture, controlActionsFuture]);

        final measurements = results[0] as List<Measurement>;
        final controlActionsResult =
            results[1] as Result<PagedResult<ControlAction>>;

        final controlActions =
            controlActionsResult is Success<PagedResult<ControlAction>>
                ? controlActionsResult.value.content
                : <ControlAction>[];

        return Result.success(CropDetails(
          crop: crop,
          measurements: measurements,
          controlActions: controlActions,
          actuatorStates: growRoom.actuatorStates,
        ));
      },
      error: (error) {
        return Result.error(error);
      },
    );
  }
}

class GetCropDetailsParams {
  final int cropId;

  GetCropDetailsParams({required this.cropId});
}

class CropDetails {
  final Crop crop;
  final List<Measurement> measurements;
  final List<ControlAction> controlActions;
  final Map<Actuator, String> actuatorStates;

  const CropDetails({
    required this.crop,
    required this.measurements,
    required this.controlActions,
    required this.actuatorStates,
  });
}
