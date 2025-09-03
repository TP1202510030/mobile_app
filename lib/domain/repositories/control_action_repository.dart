import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the control action operations.
abstract class ControlActionRepository {
  Future<List<ControlAction>> getControlActionsForCurrentPhaseByCropId(
      int cropId);

  Future<Result<List<ControlAction>>> getControlActionsByPhaseId(
      int cropPhaseId);
}
