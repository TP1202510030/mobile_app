import 'dart:developer' as developer;

enum Actuator {
  airExtractor,
  airRecirculation,
}

extension ActuatorData on Actuator {
  String get key {
    switch (this) {
      case Actuator.airExtractor:
        return 'AIR_EXTRACTOR';
      case Actuator.airRecirculation:
        return 'AIR_RECIRCULATION';
    }
  }

  static Actuator fromKey(String key) {
    return Actuator.values.firstWhere((a) => a.key == key, orElse: () {
      developer.log('Warning: Unknown actuator key: $key');
      throw ArgumentError('Unknown actuator key: $key');
    });
  }
}
