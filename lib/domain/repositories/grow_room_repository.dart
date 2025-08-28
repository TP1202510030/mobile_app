import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the grow room operations.
abstract class GrowRoomRepository {
  Future<Result<PagedResult<GrowRoom>>> getGrowRoomsByCompanyId(
      int companyId, int page, int size);

  Future<Result<GrowRoom>> getGrowRoomById(int growRoomId);
}
