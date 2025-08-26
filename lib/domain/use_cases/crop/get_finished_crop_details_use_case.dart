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
          final measurementsFuture =
              _measurementRepository.getMeasurementsByPhaseId(phase.id);
          final controlActionsFuture =
              _controlActionRepository.getControlActionsByPhaseId(phase.id);

          final results =
              await Future.wait([measurementsFuture, controlActionsFuture]);

          return PhaseDetails(
            phase: phase,
            measurements: results[0] as List<Measurement>,
            controlActions: results[1] as List<ControlAction>,
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
