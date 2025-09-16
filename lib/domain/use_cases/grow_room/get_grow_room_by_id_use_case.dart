import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetGrowRoomByIdUseCase
    implements UseCase<Result<GrowRoom>, GetGrowRoomByIdParams> {
  final GrowRoomRepository _growRoomRepository;

  GetGrowRoomByIdUseCase(this._growRoomRepository);

  @override
  Future<Result<GrowRoom>> call(GetGrowRoomByIdParams params) {
    return _growRoomRepository.getGrowRoomById(params.growRoomId);
  }
}

class GetGrowRoomByIdParams {
  final int growRoomId;

  GetGrowRoomByIdParams({required this.growRoomId});
}
