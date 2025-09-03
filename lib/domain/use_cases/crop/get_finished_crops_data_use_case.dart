import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crops_by_grow_room_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_room_by_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetFinishedCropsDataUseCase
    implements UseCase<Result<FinishedCropsData>, int> {
  final GetGrowRoomByIdUseCase _getGrowRoomByIdUseCase;
  final GetFinishedCropsByGrowRoomIdUseCase
      _getFinishedCropsByGrowRoomIdUseCase;

  GetFinishedCropsDataUseCase(
    this._getGrowRoomByIdUseCase,
    this._getFinishedCropsByGrowRoomIdUseCase,
  );

  @override
  Future<Result<FinishedCropsData>> call(int growRoomId) async {
    final growRoomResult = await _getGrowRoomByIdUseCase(
        GetGrowRoomByIdParams(growRoomId: growRoomId));

    if (growRoomResult is Error<GrowRoom>) {
      return Result.error(growRoomResult.error);
    }

    final finishedCropsResult = await _getFinishedCropsByGrowRoomIdUseCase(
        GetFinishedCropsByGrowRoomIdParams(growRoomId: growRoomId));

    return finishedCropsResult.when(
      success: (pagedResult) async {
        final growRoom = (growRoomResult as Success<GrowRoom>).value;
        return Result.success(FinishedCropsData(
          growRoomName: growRoom.name,
          finishedCrops: pagedResult.content,
        ));
      },
      error: (error) {
        return Result.error(error);
      },
    );
  }
}

class FinishedCropsData {
  final String growRoomName;
  final List<Crop> finishedCrops;

  FinishedCropsData({required this.growRoomName, required this.finishedCrops});
}
