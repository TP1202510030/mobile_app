class Measurement {
  final int id;
  final String parameter;
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
      id: json['id'],
      parameter: json['parameter'],
      value: json['value'],
      unitOfMeasurement: json['unitOfMeasurement'],
      timestamp: DateTime.parse(json['timestamp']),
      cropPhaseId: json['cropPhaseId'],
    );
  }
}
