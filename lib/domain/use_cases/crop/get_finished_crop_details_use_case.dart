import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/crop/crop_phase.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/control_action/get_control_actions_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/measurement/get_measurements_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetFinishedCropDetailsUseCase
    implements
        UseCase<Result<FinishedCropDetails>, GetFinishedCropDetailsParams> {
  final CropRepository _cropRepository;
  final GetMeasurementsByPhaseIdUseCase _getMeasurementsUseCase;
  final GetControlActionsByPhaseIdUseCase _getControlActionsUseCase;

  GetFinishedCropDetailsUseCase(
    this._cropRepository,
    this._getMeasurementsUseCase,
    this._getControlActionsUseCase,
  );

  @override
  Future<Result<FinishedCropDetails>> call(
      GetFinishedCropDetailsParams params) async {
    final cropResult = await _cropRepository.getCropById(params.cropId);

    return cropResult.when(
      success: (crop) async {
        if (crop.phases.isEmpty) {
          return Result.success(
              FinishedCropDetails(crop: crop, phaseDetails: []));
        }

        final phaseDetailFutures = crop.phases.map((phase) async {
          final measurementsResult = await _getMeasurementsUseCase(
            GetMeasurementsByPhaseIdParams(
              cropPhaseId: phase.id,
              page: ApiConstants.defaultPage,
              size: ApiConstants.defaultPageSize,
            ),
          );

          final controlActionsResult = await _getControlActionsUseCase(
            GetControlActionsByPhaseIdParams(
              cropPhaseId: phase.id,
              page: ApiConstants.defaultPage,
              size: ApiConstants.defaultPageSize,
            ),
          );

          final measurements =
              measurementsResult is Success<PagedResult<Measurement>>
                  ? measurementsResult.value
                  : PagedResult<Measurement>.empty();

          final controlActions =
              controlActionsResult is Success<PagedResult<ControlAction>>
                  ? controlActionsResult.value
                  : PagedResult<ControlAction>.empty();

          return PhaseDetails(
            phase: phase,
            measurements: measurements,
            controlActions: controlActions,
          );
        }).toList();

        final phaseDetails = await Future.wait(phaseDetailFutures);

        return Result.success(
            FinishedCropDetails(crop: crop, phaseDetails: phaseDetails));
      },
      error: (error) {
        return Result.error(error);
      },
    );
  }
}

class GetFinishedCropDetailsParams {
  final int cropId;

  GetFinishedCropDetailsParams({required this.cropId});
}

class FinishedCropDetails {
  final Crop crop;
  final List<PhaseDetails> phaseDetails;

  const FinishedCropDetails({required this.crop, required this.phaseDetails});
}

class PhaseDetails {
  final CropPhase phase;
  final PagedResult<Measurement> measurements;
  final PagedResult<ControlAction> controlActions;

  const PhaseDetails({
    required this.phase,
    required this.measurements,
    required this.controlActions,
  });
}
