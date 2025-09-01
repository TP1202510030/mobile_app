import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/create_crop_request.dart';
import 'package:mobile_app/data/models/finish_crop_request.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/crop_service.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/repositories/crop_repository.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/utils/result.dart';

/// Concrete implementation of [CropRepository].
class CropRepositoryImpl implements CropRepository {
  final CropService _cropService;

  static const int _defaultPage = ApiConstants.defaultPage;
  static const int _defaultPageSize = ApiConstants.defaultPageSize;

  CropRepositoryImpl(this._cropService);

  @override
  Future<Result<Crop>> getCropById(int cropId) async {
    try {
      final crop = await _cropService.getCropById(cropId);
      return Result.success(crop);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<PagedResult<Crop>>> getCropsByGrowRoomId(int growRoomId) async {
    try {
      final pagedResult = await _cropService.getCropsByGrowRoomId(
          growRoomId, _defaultPage, _defaultPageSize);
      return Result.success(pagedResult);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<PagedResult<Crop>>> getFinishedCropsByGrowRoomId(
      int growRoomId) async {
    try {
      final pagedResult = await _cropService.getFinishedCropsByGrowRoomId(
          growRoomId, _defaultPage, _defaultPageSize);
      return Result.success(pagedResult);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Crop>> createCrop(
      int growRoomId, CreateCropRequest cropRequest) async {
    try {
      final newCrop =
          await _cropService.createCropByGrowRoomId(growRoomId, cropRequest);
      return Result.success(newCrop);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> advanceCropPhase(int cropId) async {
    try {
      await _cropService.advanceCropPhaseByCropId(cropId);
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> finishCrop(int cropId, double totalProduction) async {
    try {
      final request = FinishCropRequest(totalProduction: totalProduction);
      await _cropService.finishCropByCropId(cropId, request);
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }
}
