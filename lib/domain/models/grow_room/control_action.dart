class ControlAction {
  final int id;
  final String actuatorType;
  final String controlActionType;
  final String triggeringReason;
  final String triggeringParameterType;
  final double? triggeringMeasurementValue;
  final DateTime timestamp;
  final int cropPhaseId;

  ControlAction({
    required this.id,
    required this.actuatorType,
    required this.controlActionType,
    required this.triggeringReason,
    required this.triggeringParameterType,
    this.triggeringMeasurementValue,
    required this.timestamp,
    required this.cropPhaseId,
  });

  factory ControlAction.fromJson(Map<String, dynamic> json) {
    return ControlAction(
      id: json['id'],
      actuatorType: json['actuatorType'],
      controlActionType: json['controlActionType'],
      triggeringReason: json['triggeringReason'],
      triggeringParameterType: json['triggeringParameterType'],
      triggeringMeasurementValue: json['triggeringMeasurementValue'],
      timestamp: DateTime.parse(json['timestamp']),
      cropPhaseId: json['cropPhaseId'],
    );
  }
}
