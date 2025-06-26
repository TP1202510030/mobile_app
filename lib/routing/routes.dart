abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const notifications = '/notifications';
  static const crop = '/crop/:cropId';
  static const createCrop = '/stepper/:growRoomId';
  static const archive = '/archive';
  static const finishedCrops = '/archive/grow-room/:growRoomId';
  static const finishedCropDetail =
      '/archive/grow-room/:growRoomId/crop/:cropId';
}
