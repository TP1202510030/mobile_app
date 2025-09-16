/// A class that holds screen paths for the entire application.
abstract final class AppRoutes {
  // --- Authentication Routes ---
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';

  // --- Main Application / Base Routes ---
  static const home = '/'; // The default screen after login
  static const activeCrop = '/crop/:cropId';
  static const archive = '/archive';
  static const notifications = '/notifications';

  // --- Relative Path Segments ---
  // These are used to build nested routes. They do NOT start with a '/'.
  // They will be appended to a parent route's path.
  static const createCropRelative = 'create-crop';
  static const cropDetailRelative = 'crop/:cropId';
  static const finishedCropListRelative = ':growRoomId';
  static const finishedCropDetailRelative = ':growRoomId/crop/:cropId';

  static const createCrop = '/grow-room/:growRoomId/create-crop';

  // --- Navigation Helper Methods ---
  // These methods provide a type-safe and centralized way to build routes
  // for navigation calls, preventing typos.
  // Example usage: context.go(AppRoutes.createCrop(growRoomId: '123'));

  /// Path: /crop/:cropId
  static String cropDetail({required String cropId}) => '/crop/$cropId';

  /// Path: /archive/:growRoomId
  static String finishedCropList({required String growRoomId}) =>
      '$archive/$growRoomId';

  /// Path: /archive/:growRoomId/crop/:cropId
  static String finishedCropDetail(
          {required String growRoomId, required String cropId}) =>
      '$archive/$growRoomId/crop/$cropId';

  static String startCreateCrop({required String growRoomId}) =>
      '/grow-room/$growRoomId/create-crop';
}
