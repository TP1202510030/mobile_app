import 'dart:developer' as developer;

enum Parameter {
  airHumidity,
  airTemperature,
  carbonDioxide,
  soilMoisture,
  soilTemperature,
}

extension ParameterData on Parameter {
  String get key {
    switch (this) {
      case Parameter.airHumidity:
        return 'AIR_HUMIDITY';
      case Parameter.airTemperature:
        return 'AIR_TEMPERATURE';
      case Parameter.carbonDioxide:
        return 'CARBON_DIOXIDE';
      case Parameter.soilMoisture:
        return 'SOIL_MOISTURE';
      case Parameter.soilTemperature:
        return 'SOIL_TEMPERATURE';
    }
  }

  static Parameter fromKey(String key) {
    return Parameter.values.firstWhere(
      (p) => p.key == key,
      orElse: () {
        developer.log('Warning: Unknown parameter key: $key');
        throw ArgumentError('Unknown parameter key: $key');
      },
    );
  }
}
