import 'package:mobile_app/ui/core/themes/icons.dart';

enum Actuator {
  airExtractor,
  airRecirculation,
}

extension ActuatorInfo on Actuator {
  String get key {
    switch (this) {
      case Actuator.airExtractor:
        return 'AIR_EXTRACTOR';
      case Actuator.airRecirculation:
        return 'AIR_RECIRCULATION';
    }
  }

  String get label {
    switch (this) {
      case Actuator.airExtractor:
        return 'Extractores';
      case Actuator.airRecirculation:
        return 'Recirculación';
    }
  }

  String get iconPath {
    switch (this) {
      case Actuator.airExtractor:
        return AppIcons.extractor;
      case Actuator.airRecirculation:
        return AppIcons.recirculation;
    }
  }

  static Actuator fromKey(String key) {
    return Actuator.values.firstWhere(
      (a) => a.key == key,
      orElse: () => throw ArgumentError('Clave de actuador desconocida: $key'),
    );
  }
}
