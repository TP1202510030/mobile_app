import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/crop/crop_phase.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetFinishedCropDetailsUseCase
    implements
        UseCase<Result<FinishedCropDetails>, GetFinishedCropDetailsParams> {
  final CropRepository _cropRepository;
  final MeasurementRepository _measurementRepository;
  final ControlActionRepository _controlActionRepository;

  GetFinishedCropDetailsUseCase(
    this._cropRepository,
    this._measurementRepository,
    this._controlActionRepository,
  );

  Future<List<Measurement>> _fetchAllMeasurementsForPhase(int phaseId) async {
    final allMeasurements = <Measurement>[];
    int currentPage = 0;
    bool isLastPage = false;

    while (!isLastPage) {
      final result = await _measurementRepository.getMeasurementsByPhaseId(
        phaseId,
        currentPage,
        ApiConstants.defaultPageSize,
      );

      if (result is Success<PagedResult<Measurement>>) {
        allMeasurements.addAll(result.value.content);
        isLastPage = result.value.isLast;
        currentPage++;
      } else {
        isLastPage = true;
      }
    }
    return allMeasurements;
  }

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
          final measurements = await _fetchAllMeasurementsForPhase(phase.id);

          final controlActionsResult =
              await _controlActionRepository.getControlActionsByPhaseId(
            phase.id,
            ApiConstants.defaultPage,
            ApiConstants.defaultPageSize,
          );

          List<ControlAction> controlActions =
              controlActionsResult is Success<PagedResult<ControlAction>>
                  ? controlActionsResult.value.content
                  : [];

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
  final List<Measurement> measurements;
  final List<ControlAction> controlActions;

  const PhaseDetails({
    required this.phase,
    required this.measurements,
    required this.controlActions,
  });
}
