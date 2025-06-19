import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';

class IconUtils {
  static String getIconForParameter(Parameter param) {
    return param.iconPath;
  }

  static String getIconForActuator(String name) {
    switch (name) {
      case 'AIR_EXTRACTOR':
        return AppIcons.extractor;
      case 'AIR_RECIRCULATION':
        return AppIcons.recirculation;
      default:
        return AppIcons.notAvailable;
    }
  }
}
