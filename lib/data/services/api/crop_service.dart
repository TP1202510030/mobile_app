import 'package:dio/dio.dart';
import 'package:mobile_app/config/api_routes.dart';
import 'package:mobile_app/data/models/create_crop_request.dart';
import 'package:mobile_app/data/models/finish_crop_request.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';

class CropService {
  final ApiClient _apiClient;

  CropService(this._apiClient);

  Future<Crop> getCropById(int cropId) async {
    final url = ApiRoutes.cropById(cropId);
    try {
      final response = await _apiClient.get(url);
      return Crop.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to get crop details.");
    }
  }

  Future<Crop> createCropByGrowRoomId(
      int growRoomId, CreateCropRequest cropRequest) async {
    final url = ApiRoutes.createCrop(growRoomId);
    try {
      final response = await _apiClient.post(
        url,
        data: cropRequest.toJson(),
      );
      return Crop.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to create crop.");
    }
  }

  Future<void> advanceCropPhaseByCropId(int cropId) async {
    final url = ApiRoutes.advanceCropPhase(cropId);
    try {
      await _apiClient.post(url);
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to advance crop phase.");
    }
  }

  Future<void> finishCropByCropId(
      int cropId, FinishCropRequest finishRequest) async {
    final url = ApiRoutes.finishCrop(cropId);
    try {
      await _apiClient.post(
        url,
        data: finishRequest.toJson(),
      );
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to finish crop.");
    }
  }

  Future<PagedResult<Crop>> getCropsByGrowRoomId(
      int growRoomId, int page, int size) async {
    final url = ApiRoutes.cropsByGrowRoomId(growRoomId);
    try {
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return PagedResult.fromJson(response.data, (json) => Crop.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to fetch crops.");
    }
  }

  Future<PagedResult<Crop>> getFinishedCropsByGrowRoomId(
      int growRoomId, int page, int size) async {
    final url = ApiRoutes.finishedCropsByGrowRoomId(growRoomId);
    try {
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return PagedResult.fromJson(response.data, (json) => Crop.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to fetch finished crops.");
    }
  }
}
