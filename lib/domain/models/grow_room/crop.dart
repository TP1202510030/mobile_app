import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class Crop {
  final int id;
  final DateTime startDate;
  final DateTime? endDate;
  final Duration sensorActivationFrequency;
  final int growRoomId;
  final List<CropPhase> phases;
  final CropPhase? currentPhase;

  Crop({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.sensorActivationFrequency,
    required this.growRoomId,
    required this.phases,
    this.currentPhase,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      sensorActivationFrequency: json['sensorActivationFrequency'],
      growRoomId: json['growRoomId'],
      currentPhase: json['currentPhase'] != null
          ? CropPhase.fromJson(json['currentPhase'])
          : null,
      phases:
          (json['phases'] as List).map((p) => CropPhase.fromJson(p)).toList(),
    );
  }
}

class CropPhase {
  final int id;
  final String name;
  final Duration duration;
  final ParameterThresholds thresholds;
  final List<Measurement> measurements;

  CropPhase({
    required this.id,
    required this.name,
    required this.duration,
    required this.thresholds,
    required this.measurements,
  });

  factory CropPhase.fromJson(Map<String, dynamic> json) {
    return CropPhase(
      id: json['id'],
      name: json['name'],
      duration: Duration(seconds: json['duration']),
      thresholds: ParameterThresholds.fromJson(json['thresholds']),
      measurements: (json['measurements'] as List)
          .map((m) => Measurement.fromJson(m))
          .toList(),
    );
  }
}

class ParameterThresholds {
  final double airTemperatureMin;
  final double airTemperatureMax;
  final double airHumidityMin;
  final double airHumidityMax;
  final double soilTemperatureMin;
  final double soilTemperatureMax;
  final double soilMoistureMin;
  final double soilMoistureMax;

  ParameterThresholds({
    required this.airTemperatureMin,
    required this.airTemperatureMax,
    required this.airHumidityMin,
    required this.airHumidityMax,
    required this.soilTemperatureMin,
    required this.soilTemperatureMax,
    required this.soilMoistureMin,
    required this.soilMoistureMax,
  });

  factory ParameterThresholds.fromJson(Map<String, dynamic> json) {
    return ParameterThresholds(
      airTemperatureMin: json['airTemperatureMin'],
      airTemperatureMax: json['airTemperatureMax'],
      airHumidityMin: json['airHumidityMin'],
      airHumidityMax: json['airHumidityMax'],
      soilTemperatureMin: json['soilTemperatureMin'],
      soilTemperatureMax: json['soilTemperatureMax'],
      soilMoistureMin: json['soilMoistureMin'],
      soilMoistureMax: json['soilMoistureMax'],
    );
  }
}
