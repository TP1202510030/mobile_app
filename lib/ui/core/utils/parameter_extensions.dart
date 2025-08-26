import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';

extension ParameterUI on Parameter {
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
}
