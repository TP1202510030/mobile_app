import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetMeasurementsByPhaseIdUseCase
    implements
        UseCase<Result<PagedResult<Measurement>>,
            GetMeasurementsByPhaseIdParams> {
  final MeasurementRepository _measurementRepository;

  GetMeasurementsByPhaseIdUseCase(this._measurementRepository);

  @override
  Future<Result<PagedResult<Measurement>>> call(
      GetMeasurementsByPhaseIdParams params) {
    return _measurementRepository.getMeasurementsByPhaseId(
        params.cropPhaseId, params.page, params.size);
  }
}

class GetMeasurementsByPhaseIdParams {
  final int cropPhaseId;
  final int page;
  final int size;

  GetMeasurementsByPhaseIdParams({
    required this.cropPhaseId,
    required this.page,
    required this.size,
  });
}
