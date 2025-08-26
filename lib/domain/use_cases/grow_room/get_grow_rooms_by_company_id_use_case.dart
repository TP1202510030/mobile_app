import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';

/// Caso de uso para obtener la lista de GrowRooms para una compañía.
class GetGrowRoomsByCompanyIdUseCase
    implements UseCase<List<GrowRoom>, GetGrowRoomsByCompanyIdParams> {
  final GrowRoomRepository _growRoomRepository;

  GetGrowRoomsByCompanyIdUseCase(this._growRoomRepository);

  @override
  Future<List<GrowRoom>> call(GetGrowRoomsByCompanyIdParams params) {
    return _growRoomRepository.getGrowRoomsByCompanyId(params.companyId);
  }
}

class GetGrowRoomsByCompanyIdParams {
  final int companyId;

  GetGrowRoomsByCompanyIdParams({required this.companyId});
}
