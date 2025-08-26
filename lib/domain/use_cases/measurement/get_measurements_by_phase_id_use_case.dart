import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/repositories/measurement_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';

class GetMeasurementsByPhaseIdUseCase
    implements UseCase<List<Measurement>, GetMeasurementsByPhaseIdParams> {
  final MeasurementRepository _measurementRepository;

  GetMeasurementsByPhaseIdUseCase(this._measurementRepository);

  @override
  Future<List<Measurement>> call(GetMeasurementsByPhaseIdParams params) {
    return _measurementRepository.getMeasurementsByPhaseId(params.cropPhaseId);
  }
}

class GetMeasurementsByPhaseIdParams {
  final int cropPhaseId;

  GetMeasurementsByPhaseIdParams({required this.cropPhaseId});
}
