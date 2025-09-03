import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the measurement operations.
abstract class MeasurementRepository {
  Future<List<Measurement>> getMeasurementsForCurrentPhaseByCropId(int cropId);

  Future<Result<List<Measurement>>> getMeasurementsByPhaseId(int cropPhaseId);
}
