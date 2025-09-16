import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

/// Use Case for finishing a crop.
///
/// Responsible for calling the repository to set the end date
/// of a crop and record the total production obtained.
class FinishCropUseCase implements UseCase<Result<void>, FinishCropParams> {
  final CropRepository _cropRepository;

  FinishCropUseCase(this._cropRepository);

  @override
  Future<Result<void>> call(FinishCropParams params) {
    return _cropRepository.finishCrop(params.cropId, params.totalProduction);
  }
}

class FinishCropParams {
  final int cropId;
  final double totalProduction;

  FinishCropParams({required this.cropId, required this.totalProduction});
}
