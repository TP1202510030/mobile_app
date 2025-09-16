import 'package:dio/dio.dart';
import 'package:mobile_app/config/api_routes.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';

class MeasurementService {
  final ApiClient _apiClient;

  MeasurementService(this._apiClient);

  Future<PagedResult<Measurement>> getMeasurementsForCurrentPhaseByCropId(
    int cropId,
    int page,
    int size,
  ) async {
    final url = ApiRoutes.measurementsForCurrentPhaseByCropId(cropId);
    try {
      final response = await _apiClient.get(
        url,
        queryParameters: {'page': page, 'size': size},
      );
      return PagedResult.fromJson(
          response.data, (json) => Measurement.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(
          message: "Failed to fetch current phase measurements.");
    }
  }

  Future<PagedResult<Measurement>> getMeasurementsByPhaseId(
    int cropPhaseId,
    int page,
    int size,
  ) async {
    final url = ApiRoutes.measurementsByPhaseId(cropPhaseId);
    try {
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        return PagedResult.empty();
      }

      return PagedResult.fromJson(
          response.data, (json) => Measurement.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to fetch measurements.");
    }
  }
}
