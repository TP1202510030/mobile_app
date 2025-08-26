import 'package:dio/dio.dart';
import 'package:mobile_app/config/api_routes.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';

import 'package:mobile_app/core/exceptions/api_exception.dart';

class ControlActionService {
  final ApiClient _apiClient;

  ControlActionService(this._apiClient);

  Future<PagedResult<ControlAction>> getControlActionsByCropPhaseId(
      int cropPhaseId, int page, int size) async {
    try {
      final url = ApiRoutes.controlActionsByPhaseId(cropPhaseId);
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return PagedResult.fromJson(
          response.data, (json) => ControlAction.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(message: "Failed to fetch control actions.");
    }
  }

  Future<PagedResult<ControlAction>> getControlActionsForCurrentPhase(
      int cropId, int page, int size) async {
    try {
      final url = ApiRoutes.controlActionsForCurrentPhaseByCropId(cropId);
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return PagedResult.fromJson(
          response.data, (json) => ControlAction.fromJson(json));
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error!;
      throw ApiException(
          message: "Failed to fetch current phase control actions.");
    }
  }
}
