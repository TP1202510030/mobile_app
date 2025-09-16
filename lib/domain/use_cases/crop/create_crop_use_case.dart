import 'package:mobile_app/data/models/create_crop_request.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class CreateCropUseCase implements UseCase<Result<Crop>, CreateCropParams> {
  final CropRepository _cropRepository;

  CreateCropUseCase(this._cropRepository);

  @override
  Future<Result<Crop>> call(CreateCropParams params) {
    final cropRequest = CreateCropRequest(
      sensorActivationFrequency: params.sensorActivationFrequency,
      phases: params.phases
          .map((p) => CreateCropPhase(
                name: p.name,
                phaseDuration: p.phaseDuration,
                parameterThresholds: p.parameterThresholds,
              ))
          .toList(),
    );

    return _cropRepository.createCrop(params.growRoomId, cropRequest);
  }
}

class CreateCropParams {
  final int growRoomId;
  final String sensorActivationFrequency;
  final List<CreateCropPhaseParams> phases;

  CreateCropParams({
    required this.growRoomId,
    required this.sensorActivationFrequency,
    required this.phases,
  });
}

class CreateCropPhaseParams {
  final String name;
  final String phaseDuration;
  final Map<String, double> parameterThresholds;

  CreateCropPhaseParams({
    required this.name,
    required this.phaseDuration,
    required this.parameterThresholds,
  });
}
