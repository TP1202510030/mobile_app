import 'package:mobile_app/core/exceptions/api_exception.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/data/services/api/control_action_service.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/utils/result.dart';

/// Concrete implementation of [ControlActionRepository].
class ControlActionRepositoryImpl implements ControlActionRepository {
  final ControlActionService _controlActionService;

  ControlActionRepositoryImpl(this._controlActionService);

  @override
  Future<Result<PagedResult<ControlAction>>>
      getControlActionsForCurrentPhaseByCropId(
          int cropId, int page, int size) async {
    try {
      final pagedResult = await _controlActionService
          .getControlActionsForCurrentPhase(cropId, page, size);
      return Result.success(pagedResult);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<PagedResult<ControlAction>>> getControlActionsByPhaseId(
      int cropPhaseId, int page, int size) async {
    try {
      final pagedResult = await _controlActionService
          .getControlActionsByCropPhaseId(cropPhaseId, page, size);
      return Result.success(pagedResult);
    } on ApiException catch (e) {
      return Result.error(e);
    }
  }
}
