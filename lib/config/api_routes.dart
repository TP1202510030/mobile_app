/// A collection of static API route definitions and builders for the application.
///
/// This abstract final class provides string constants and methods to construct
/// API endpoint URLs for various resources such as authentication, grow rooms,
/// crops, measurements, and control actions.
abstract final class ApiRoutes {
  static const String _authBase = '/api/v1/authentication';
  static const String signIn = '$_authBase/sign-in';

  static const String _companiesBase = '/api/v1/companies';
  static String growRoomsByCompanyId(int companyId) =>
      '$_companiesBase/$companyId/grow_rooms';

  static const String _growRoomsBase = '/api/v1/grow_rooms';
  static String growRoomById(int growRoomId) => '$_growRoomsBase/$growRoomId';
  static String cropsByGrowRoomId(int growRoomId) =>
      '$_growRoomsBase/$growRoomId/crops';
  static String finishedCropsByGrowRoomId(int growRoomId) =>
      '$_growRoomsBase/$growRoomId/crops/finished';
  static String createCrop(int growRoomId) =>
      '$_growRoomsBase/$growRoomId/crops';

  static const String _cropsBase = '/api/v1/crops';
  static String cropById(int cropId) => '$_cropsBase/$cropId';
  static String advanceCropPhase(int cropId) =>
      '$_cropsBase/$cropId/advancePhase';
  static String finishCrop(int cropId) => '$_cropsBase/$cropId/finish';
  static String measurementsForCurrentPhaseByCropId(int cropId) =>
      '$_cropsBase/$cropId/measurements';
  static String controlActionsForCurrentPhaseByCropId(int cropId) =>
      '$_cropsBase/$cropId/control-actions';

  static const String _phaseBase = '/api/v1/crop_phases';
  static String measurementsByPhaseId(int phaseId) =>
      '$_phaseBase/$phaseId/measurements';
  static String controlActionsByPhaseId(int phaseId) =>
      '$_phaseBase/$phaseId/control-actions';
}
