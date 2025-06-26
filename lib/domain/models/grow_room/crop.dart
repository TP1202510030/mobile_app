import 'package:mobile_app/domain/models/grow_room/measurement.dart';

Duration _parseIso8601Duration(String isoString) {
  if (!isoString.contains('T') &&
      isoString.startsWith('P') &&
      isoString.endsWith('D')) {
    final days = int.tryParse(isoString.substring(1, isoString.length - 1));
    return Duration(days: days ?? 0);
  }

  if (!isoString.startsWith('PT')) {
    if (isoString.startsWith('P') && !isoString.contains('T')) {
      return Duration(
          days: int.tryParse(isoString.replaceAll(RegExp(r'[PD]'), '')) ?? 0);
    }
    throw FormatException("Invalid ISO 8601 duration format", isoString);
  }
  try {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    String durationPart = isoString.substring(2);

    final hoursMatch = RegExp(r'(\d+)H').firstMatch(durationPart);
    if (hoursMatch != null) {
      hours = int.parse(hoursMatch.group(1)!);
    }

    final minutesMatch = RegExp(r'(\d+)M').firstMatch(durationPart);
    if (minutesMatch != null) {
      minutes = int.parse(minutesMatch.group(1)!);
    }

    final secondsMatch = RegExp(r'(\d+)S').firstMatch(durationPart);
    if (secondsMatch != null) {
      seconds = int.parse(secondsMatch.group(1)!);
    }

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  } catch (e) {
    throw FormatException("Error parsing ISO 8601 duration", isoString);
  }
}

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
    final phasesList = json['phases'] as List<dynamic>? ?? [];

    return Crop(
      id: json['id'],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      sensorActivationFrequency:
          _parseIso8601Duration(json['sensorActivationFrequency'] as String),
      growRoomId: json['growRoomId'],
      currentPhase: json['currentPhase'] != null
          ? CropPhase.fromJson(json['currentPhase'] as Map<String, dynamic>)
          : null,
      phases: phasesList
          .where((p) => p != null)
          .map((p) => CropPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
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
    final measurementsList = json['measurements'] as List<dynamic>? ?? [];

    final thresholdsData = json['thresholds'] as Map<String, dynamic>? ?? {};

    return CropPhase(
      id: json['id'],
      name: json['name'],
      duration: _parseIso8601Duration(json['duration'] as String),
      thresholds: ParameterThresholds.fromJson(thresholdsData),
      measurements: measurementsList
          .where((m) => m != null)
          .map((m) => Measurement.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ParameterThresholds {
  final double airTemperatureMin;
  final double airTemperatureMax;
  final double airHumidityMin;
  final double airHumidityMax;
  final double carbonDioxideMin;
  final double carbonDioxideMax;
  final double soilTemperatureMin;
  final double soilTemperatureMax;
  final double soilMoistureMin;
  final double soilMoistureMax;

  ParameterThresholds({
    required this.airTemperatureMin,
    required this.airTemperatureMax,
    required this.airHumidityMin,
    required this.airHumidityMax,
    required this.carbonDioxideMin,
    required this.carbonDioxideMax,
    required this.soilTemperatureMin,
    required this.soilTemperatureMax,
    required this.soilMoistureMin,
    required this.soilMoistureMax,
  });

  factory ParameterThresholds.fromJson(Map<String, dynamic> json) {
    return ParameterThresholds(
      airTemperatureMin: (json['airTemperatureMin'] as num?)?.toDouble() ?? 0.0,
      airTemperatureMax: (json['airTemperatureMax'] as num?)?.toDouble() ?? 0.0,
      airHumidityMin: (json['airHumidityMin'] as num?)?.toDouble() ?? 0.0,
      airHumidityMax: (json['airHumidityMax'] as num?)?.toDouble() ?? 0.0,
      carbonDioxideMin: (json['carbonDioxideMin'] as num?)?.toDouble() ?? 0.0,
      carbonDioxideMax: (json['carbonDioxideMax'] as num?)?.toDouble() ?? 0.0,
      soilTemperatureMin:
          (json['soilTemperatureMin'] as num?)?.toDouble() ?? 0.0,
      soilTemperatureMax:
          (json['soilTemperatureMax'] as num?)?.toDouble() ?? 0.0,
      soilMoistureMin: (json['soilMoistureMin'] as num?)?.toDouble() ?? 0.0,
      soilMoistureMax: (json['soilMoistureMax'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
