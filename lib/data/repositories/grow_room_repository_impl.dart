import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/grow_room_service.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/utils/result.dart';

class GrowRoomRepositoryImpl implements GrowRoomRepository {
  final GrowRoomService _growRoomService;

  GrowRoomRepositoryImpl(this._growRoomService);

  @override
  Future<Result<PagedResult<GrowRoom>>> getGrowRoomsByCompanyId(
      int companyId, int page, int size) async {
    try {
      final pagedResult =
          await _growRoomService.getGrowRoomsByCompanyId(companyId, page, size);
      return Result.success(pagedResult);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<GrowRoom>> getGrowRoomById(int growRoomId) async {
    try {
      final growRoom = await _growRoomService.getGrowRoomById(growRoomId);
      return Result.success(growRoom);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }
}
