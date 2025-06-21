import 'package:mobile_app/ui/core/themes/icons.dart';

enum Actuator {
  airExtractor,
  airRecirculation,
}

extension ActuatorInfo on Actuator {
  /// La clave usada en el backend.
  String get key {
    switch (this) {
      case Actuator.airExtractor:
        return 'AIR_EXTRACTOR';
      case Actuator.airRecirculation:
        return 'AIR_RECIRCULATION';
    }
  }

  /// La etiqueta para la UI.
  String get label {
    switch (this) {
      case Actuator.airExtractor:
        return 'Extractores';
      case Actuator.airRecirculation:
        return 'Recirculación';
    }
  }

  /// La ruta del icono SVG.
  String get iconPath {
    switch (this) {
      case Actuator.airExtractor:
        return AppIcons.extractor;
      case Actuator.airRecirculation:
        return AppIcons.recirculation;
    }
  }

  /// Convierte una clave String de vuelta al enum.
  static Actuator fromKey(String key) {
    return Actuator.values.firstWhere(
      (a) => a.key == key,
      orElse: () => throw ArgumentError('Clave de actuador desconocida: $key'),
    );
  }
}
