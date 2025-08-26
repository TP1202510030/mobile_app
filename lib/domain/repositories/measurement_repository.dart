import 'package:mobile_app/domain/entities/measurement/measurement.dart';

/// Contract that defines the measurement operations.
abstract class MeasurementRepository {
  Future<List<Measurement>> getMeasurementsForCurrentPhaseByCropId(int cropId);

  Future<List<Measurement>> getMeasurementsByPhaseId(int cropPhaseId);
}
