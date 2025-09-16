import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/utils/result.dart';

/// Contract that defines the control action operations.
abstract class ControlActionRepository {
  Future<Result<PagedResult<ControlAction>>>
      getControlActionsForCurrentPhaseByCropId(int cropId, int page, int size);

  Future<Result<PagedResult<ControlAction>>> getControlActionsByPhaseId(
      int cropPhaseId, int page, int size);
}
