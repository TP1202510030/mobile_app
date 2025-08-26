import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';

class GetFinishedCropsByGrowRoomIdUseCase
    implements UseCase<List<Crop>, GetFinishedCropsByGrowRoomIdParams> {
  final CropRepository _cropRepository;

  GetFinishedCropsByGrowRoomIdUseCase(this._cropRepository);

  @override
  Future<List<Crop>> call(GetFinishedCropsByGrowRoomIdParams params) {
    return _cropRepository.getFinishedCropsByGrowRoomId(params.growRoomId);
  }
}

class GetFinishedCropsByGrowRoomIdParams {
  final int growRoomId;

  GetFinishedCropsByGrowRoomIdParams({required this.growRoomId});
}
