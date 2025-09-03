import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/data/services/api/measurement_service.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/utils/result.dart';

/// Concrete implementation of [MeasurementRepository].
class MeasurementRepositoryImpl implements MeasurementRepository {
  final MeasurementService _measurementService;

  static const int _defaultPage = ApiConstants.defaultPage;
  static const int _defaultPageSize = ApiConstants.defaultPageSize;

  MeasurementRepositoryImpl(this._measurementService);

  @override
  Future<List<Measurement>> getMeasurementsForCurrentPhaseByCropId(
      int cropId) async {
    try {
      final pagedResult =
          await _measurementService.getMeasurementsForCurrentPhaseByCropId(
              cropId, _defaultPage, _defaultPageSize);
      return pagedResult.content;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Result<List<Measurement>>> getMeasurementsByPhaseId(
      int cropPhaseId) async {
    try {
      final pagedResult = await _measurementService.getMeasurementsByPhaseId(
          cropPhaseId, _defaultPage, _defaultPageSize);
      return Result.success(pagedResult.content);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }
}
