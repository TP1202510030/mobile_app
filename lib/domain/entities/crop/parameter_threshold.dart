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
      airTemperatureMin: (json['airTemperatureMin'] as num).toDouble(),
      airTemperatureMax: (json['airTemperatureMax'] as num).toDouble(),
      airHumidityMin: (json['airHumidityMin'] as num).toDouble(),
      airHumidityMax: (json['airHumidityMax'] as num).toDouble(),
      carbonDioxideMin: (json['carbonDioxideMin'] as num).toDouble(),
      carbonDioxideMax: (json['carbonDioxideMax'] as num).toDouble(),
      soilTemperatureMin: (json['soilTemperatureMin'] as num).toDouble(),
      soilTemperatureMax: (json['soilTemperatureMax'] as num).toDouble(),
      soilMoistureMin: (json['soilMoistureMin'] as num).toDouble(),
      soilMoistureMax: (json['soilMoistureMax'] as num).toDouble(),
    );
  }
}
