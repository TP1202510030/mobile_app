import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action_type.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/utils/date_parser.dart';

class ControlAction {
  final int id;
  final Actuator actuatorType;
  final ControlActionType controlActionType;
  final String triggeringReason;
  final Parameter triggeringParameterType;
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
      id: json['id'] as int,
      actuatorType: ActuatorData.fromKey(json['actuatorType'] as String),
      controlActionType:
          ControlActionTypeData.fromKey(json['controlActionType'] as String),
      triggeringReason: json['triggeringReason'] as String,
      triggeringParameterType:
          ParameterData.fromKey(json['triggeringParameterType'] as String),
      triggeringMeasurementValue:
          (json['triggeringMeasurementValue'] as num?)?.toDouble(),
      timestamp: parseCustomDate(json['timestamp'] as String),
      cropPhaseId: json['cropPhaseId'] as int,
    );
  }
}
