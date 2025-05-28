import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  VoidCallback? onNotificationTap;

  bool _hasNotification = false;

  bool get hasNotification => _hasNotification;

  set hasNotification(bool value) {
    if (_hasNotification != value) {
      _hasNotification = value;
      notifyListeners();
    }
  }

  void handleNotificationTap() {
    if (onNotificationTap != null) {
      onNotificationTap!();
    }
  }

  HomeViewModel();
}
