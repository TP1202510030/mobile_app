import 'package:mobile_app/data/models/create_crop_request.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the crop operations.
abstract class CropRepository {
  Future<Result<Crop>> getCropById(int cropId);

  Future<List<Crop>> getCropsByGrowRoomId(int growRoomId);

  Future<List<Crop>> getFinishedCropsByGrowRoomId(int growRoomId);

  Future<Result<Crop>> createCrop(
      int growRoomId, CreateCropRequest cropRequest);

  Future<Result<void>> advanceCropPhase(int cropId);

  Future<Result<void>> finishCrop(int cropId, double totalProduction);
}
