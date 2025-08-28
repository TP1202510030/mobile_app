import 'package:dio/dio.dart';
import 'package:mobile_app/config/api_routes.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/api_client.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';

class GrowRoomService {
  final ApiClient _apiClient;

  GrowRoomService(this._apiClient);

  Future<GrowRoom> getGrowRoomById(int id) async {
    final url = ApiRoutes.growRoomById(id);
    try {
      final response = await _apiClient.get(url);
      return GrowRoom.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<PagedResult<GrowRoom>> getGrowRoomsByCompanyId(
    int companyId,
    int page,
    int size,
  ) async {
    final url = ApiRoutes.growRoomsByCompanyId(companyId);
    try {
      final response = await _apiClient.get(
        url,
        queryParameters: {
          'companyId': companyId,
          'page': page,
          'size': size,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        return PagedResult<GrowRoom>.empty();
      }

      return PagedResult.fromJson(
          response.data, (json) => GrowRoom.fromJson(json));
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }
}
