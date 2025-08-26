import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/utils/date_parser.dart';

class Measurement {
  final int id;
  final Parameter parameter;
  final double value;
  final String unitOfMeasurement;
  final DateTime timestamp;
  final int cropPhaseId;

  Measurement({
    required this.id,
    required this.parameter,
    required this.value,
    required this.unitOfMeasurement,
    required this.timestamp,
    required this.cropPhaseId,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as int,
      parameter: ParameterData.fromKey(json['parameter'] as String),
      value: (json['value'] as num).toDouble(),
      unitOfMeasurement: json['unitOfMeasurement'] as String,
      timestamp: parseCustomDate(json['timestamp'] as String),
      cropPhaseId: json['cropPhaseId'] as int,
    );
  }
}
