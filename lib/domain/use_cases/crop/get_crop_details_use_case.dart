import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetCropDetailsUseCase
    implements UseCase<Result<CropDetails>, GetCropDetailsParams> {
  final CropRepository _cropRepository;
  final MeasurementRepository _measurementRepository;
  final ControlActionRepository _controlActionRepository;

  GetCropDetailsUseCase(
    this._cropRepository,
    this._measurementRepository,
    this._controlActionRepository,
  );

  @override
  Future<Result<CropDetails>> call(GetCropDetailsParams params) async {
    final cropResult = await _cropRepository.getCropById(params.cropId);

    return cropResult.when(
      success: (crop) async {
        if (crop.currentPhase == null) {
          return Result.success(CropDetails(
            crop: crop,
            measurements: [],
            controlActions: [],
          ));
        }

        final measurementsFuture = _measurementRepository
            .getMeasurementsForCurrentPhaseByCropId(params.cropId);
        final controlActionsFuture = _controlActionRepository
            .getControlActionsForCurrentPhaseByCropId(params.cropId);

        final results =
            await Future.wait([measurementsFuture, controlActionsFuture]);

        final measurements = results[0] as List<Measurement>;
        final controlActions = results[1] as List<ControlAction>;

        return Result.success(CropDetails(
          crop: crop,
          measurements: measurements,
          controlActions: controlActions,
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

  const CropDetails({
    required this.crop,
    required this.measurements,
    required this.controlActions,
  });
}
