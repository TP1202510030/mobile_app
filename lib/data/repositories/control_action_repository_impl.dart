import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/services/api/control_action_service.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';

class ControlActionRepositoryImpl implements ControlActionRepository {
  final ControlActionService _controlActionService;

  static const int _defaultPage = ApiConstants.defaultPage;
  static const int _defaultPageSize = ApiConstants.defaultPageSize;

  ControlActionRepositoryImpl(this._controlActionService);

  @override
  Future<List<ControlAction>> getControlActionsForCurrentPhaseByCropId(
      int cropId) async {
    try {
      final pagedResult =
          await _controlActionService.getControlActionsForCurrentPhase(
              cropId, _defaultPage, _defaultPageSize);
      return pagedResult.content;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ControlAction>> getControlActionsByPhaseId(
      int cropPhaseId) async {
    try {
      final pagedResult =
          await _controlActionService.getControlActionsByCropPhaseId(
              cropPhaseId, _defaultPage, _defaultPageSize);
      return pagedResult.content;
    } catch (e) {
      return [];
    }
  }
}
