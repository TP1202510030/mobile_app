import 'package:mobile_app/ui/core/themes/icons.dart';

class IconUtils {
  static String getIconForParameter(String name) {
    switch (name) {
      case 'AIR_HUMIDITY':
        return AppIcons.airHumidity;
      case 'AIR_TEMPERATURE':
        return AppIcons.airTemperature;
      case 'CARBON_DIOXIDE':
        return AppIcons.co2;
      case 'SOIL_MOISTURE':
        return AppIcons.soilMoisture;
      case 'SOIL_TEMPERATURE':
        return AppIcons.soilTemperature;
      default:
        return AppIcons.notAvailable;
    }
  }

  static String getIconForActuator(String name) {
    switch (name) {
      case 'extractor':
        return AppIcons.extractor;
      case 'recirculation':
        return AppIcons.recirculation;
      default:
        return AppIcons.notAvailable;
    }
  }
}
