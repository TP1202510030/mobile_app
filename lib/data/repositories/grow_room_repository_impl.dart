import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/data/services/api/grow_room_service.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/grow_room_repository.dart';
import 'package:mobile_app/utils/result.dart';

class GrowRoomRepositoryImpl implements GrowRoomRepository {
  final GrowRoomService _growRoomService;

  static const int _defaultPage = ApiConstants.defaultPage;
  static const int _defaultPageSize = ApiConstants.defaultPageSize;

  GrowRoomRepositoryImpl(this._growRoomService);

  @override
  Future<List<GrowRoom>> getGrowRoomsByCompanyId(int companyId) async {
    try {
      final pagedResult = await _growRoomService.getGrowRoomsByCompanyId(
          companyId, _defaultPage, _defaultPageSize);
      return pagedResult.content;
    } catch (e) {
      return [];
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
