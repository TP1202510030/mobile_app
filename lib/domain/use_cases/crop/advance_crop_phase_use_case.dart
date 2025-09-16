import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class AdvanceCropPhaseUseCase
    implements UseCase<Result<void>, AdvanceCropPhaseParams> {
  final CropRepository _cropRepository;

  AdvanceCropPhaseUseCase(this._cropRepository);

  @override
  Future<Result<void>> call(AdvanceCropPhaseParams params) {
    return _cropRepository.advanceCropPhase(params.cropId);
  }
}

class AdvanceCropPhaseParams {
  final int cropId;

  AdvanceCropPhaseParams({required this.cropId});
}
