import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetMeasurementsByPhaseIdUseCase
    implements
        UseCase<Result<List<Measurement>>, GetMeasurementsByPhaseIdParams> {
  final MeasurementRepository _measurementRepository;

  GetMeasurementsByPhaseIdUseCase(this._measurementRepository);

  @override
  Future<Result<List<Measurement>>> call(
      GetMeasurementsByPhaseIdParams params) {
    return _measurementRepository.getMeasurementsByPhaseId(params.cropPhaseId);
  }
}

class GetMeasurementsByPhaseIdParams {
  final int cropPhaseId;

  GetMeasurementsByPhaseIdParams({required this.cropPhaseId});
}
