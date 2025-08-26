import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/parameter_threshold.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';

class CropPhase {
  final int id;
  final String name;
  final String duration;
  final ParameterThresholds thresholds;
  final List<Measurement> measurements;
  final List<ControlAction> controlActions;

  CropPhase({
    required this.id,
    required this.name,
    required this.duration,
    required this.thresholds,
    this.measurements = const [],
    this.controlActions = const [],
  });

  factory CropPhase.fromJson(Map<String, dynamic> json) {
    final measurementsList = json['measurements'] as List<dynamic>? ?? [];
    final controlActionsList = json['controlActions'] as List<dynamic>? ?? [];

    return CropPhase(
      id: json['id'] as int,
      name: json['name'] as String,
      duration: json['duration'] as String,
      thresholds: ParameterThresholds.fromJson(
          json['thresholds'] as Map<String, dynamic>),
      measurements: measurementsList
          .map((m) => Measurement.fromJson(m as Map<String, dynamic>))
          .toList(),
      controlActions: controlActionsList
          .map((ca) => ControlAction.fromJson(ca as Map<String, dynamic>))
          .toList(),
    );
  }
}
