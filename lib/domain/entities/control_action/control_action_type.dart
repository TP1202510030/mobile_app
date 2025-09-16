import 'dart:developer' as developer show log;

enum ControlActionType {
  activated,
  deactivated,
}

extension ControlActionTypeData on ControlActionType {
  String get key {
    switch (this) {
      case ControlActionType.activated:
        return 'ACTIVATED';
      case ControlActionType.deactivated:
        return 'DEACTIVATED';
    }
  }

  static ControlActionType fromKey(String key) {
    return ControlActionType.values.firstWhere((t) => t.key == key, orElse: () {
      developer.log('Warning: Unknown ControlActionType key: $key');
      throw ArgumentError('Unknown ControlActionType key: $key');
    });
  }
}
