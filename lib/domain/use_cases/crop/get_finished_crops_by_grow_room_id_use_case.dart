import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetFinishedCropsByGrowRoomIdUseCase
    implements
        UseCase<Result<PagedResult<Crop>>, GetFinishedCropsByGrowRoomIdParams> {
  final CropRepository _cropRepository;

  GetFinishedCropsByGrowRoomIdUseCase(this._cropRepository);

  @override
  Future<Result<PagedResult<Crop>>> call(
      GetFinishedCropsByGrowRoomIdParams params) {
    return _cropRepository.getFinishedCropsByGrowRoomId(params.growRoomId);
  }
}

class GetFinishedCropsByGrowRoomIdParams {
  final int growRoomId;

  GetFinishedCropsByGrowRoomIdParams({required this.growRoomId});
}
