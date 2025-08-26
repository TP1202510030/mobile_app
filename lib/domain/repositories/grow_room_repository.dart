import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the grow room operations.
abstract class GrowRoomRepository {
  Future<List<GrowRoom>> getGrowRoomsByCompanyId(int companyId);

  Future<Result<GrowRoom>> getGrowRoomById(int growRoomId);
}
