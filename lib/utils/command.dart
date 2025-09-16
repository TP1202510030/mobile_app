import 'package:flutter/foundation.dart';
import 'package:mobile_app/utils/result.dart';

enum CommandStatus { idle, running, success, error }

class Command<T, P> extends ChangeNotifier {
  Command(this._action);

  final Future<Result<T>> Function(P params) _action;

  CommandStatus _status = CommandStatus.idle;
  CommandStatus get status => _status;

  Exception? _error;
  Exception? get error => _error;

  bool get isRunning => _status == CommandStatus.running;
  bool get hasError => _status == CommandStatus.error;
  bool get isSuccess => _status == CommandStatus.success;

  Future<void> execute(P params) async {
    if (isRunning) return;

    _status = CommandStatus.running;
    _error = null;
    notifyListeners();

    final result = await _action(params);

    switch (result) {
      case Success<T>():
        _status = CommandStatus.success;
        break;
      case Error<T>(error: final e):
        _status = CommandStatus.error;
        _error = e;
        break;
    }
    notifyListeners();
  }

  void reset() {
    _status = CommandStatus.idle;
    _error = null;
    notifyListeners();
  }
}
