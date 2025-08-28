import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

/// Caso de uso para obtener la lista de GrowRooms para una compañía.
class GetGrowRoomsByCompanyIdUseCase
    implements
        UseCase<Result<PagedResult<GrowRoom>>, GetGrowRoomsByCompanyIdParams> {
  final GrowRoomRepository _growRoomRepository;

  GetGrowRoomsByCompanyIdUseCase(this._growRoomRepository);

  @override
  Future<Result<PagedResult<GrowRoom>>> call(
      GetGrowRoomsByCompanyIdParams params) {
    return _growRoomRepository.getGrowRoomsByCompanyId(
        params.companyId, params.page, params.size);
  }
}

class GetGrowRoomsByCompanyIdParams {
  final int companyId;
  final int page;
  final int size;

  GetGrowRoomsByCompanyIdParams(
      {required this.companyId, required this.page, required this.size});
}
