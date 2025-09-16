import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';

class GrowRoom {
  final int id;
  final String name;
  final String imageUrl;
  final bool hasActiveCrop;
  final int? activeCropId;
  final List<Measurement> latestMeasurements;
  final Map<Actuator, String> actuatorStates;

  GrowRoom({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.hasActiveCrop,
    this.activeCropId,
    required this.latestMeasurements,
    required this.actuatorStates,
  });

  factory GrowRoom.fromJson(Map<String, dynamic> json) {
    final latestMeasurementsList =
        json['latestMeasurements'] as List<dynamic>? ?? [];
    final actuatorStatesMap =
        json['actuatorStates'] as Map<String, dynamic>? ?? {};

    return GrowRoom(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      hasActiveCrop: json['hasActiveCrop'] as bool,
      activeCropId: json['activeCropId'] as int?,
      latestMeasurements: latestMeasurementsList
          .map((m) => Measurement.fromJson(m as Map<String, dynamic>))
          .toList(),
      actuatorStates: actuatorStatesMap.map(
        (key, value) => MapEntry(
          ActuatorData.fromKey(key),
          value as String,
        ),
      ),
    );
  }
}
