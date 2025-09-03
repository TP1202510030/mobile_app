import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';

extension ActuatorUI on Actuator {
  String get label {
    switch (this) {
      case Actuator.airExtractor:
        return 'Extracción';
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
}
