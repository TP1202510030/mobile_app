import 'package:mobile_app/ui/core/themes/icons.dart';

enum Parameter {
  airHumidity,
  airTemperature,
  carbonDioxide,
  soilMoisture,
  soilTemperature,
}

extension ParameterInfo on Parameter {
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

  String get label {
    switch (this) {
      case Parameter.airHumidity:
        return 'Humedad del aire (%)';
      case Parameter.airTemperature:
        return 'Temperatura del aire (°C)';
      case Parameter.carbonDioxide:
        return 'Dióxido de carbono (ppm)';
      case Parameter.soilMoisture:
        return 'Humedad del compost (%)';
      case Parameter.soilTemperature:
        return 'Temperatura del compost (°C)';
    }
  }

  String get iconPath {
    switch (this) {
      case Parameter.airHumidity:
        return AppIcons.airHumidity;
      case Parameter.airTemperature:
        return AppIcons.airTemperature;
      case Parameter.carbonDioxide:
        return AppIcons.co2;
      case Parameter.soilMoisture:
        return AppIcons.soilMoisture;
      case Parameter.soilTemperature:
        return AppIcons.soilTemperature;
    }
  }

  static Parameter fromKey(String key) {
    return Parameter.values.firstWhere(
      (p) => p.key == key,
      orElse: () {
        print('Advertencia: Clave de parámetro desconocida: $key');
        return Parameter.airTemperature;
      },
    );
  }
}
