import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetControlActionsByPhaseIdUseCase
    implements
        UseCase<Result<List<ControlAction>>, GetControlActionsByPhaseIdParams> {
  final ControlActionRepository _controlActionRepository;

  GetControlActionsByPhaseIdUseCase(this._controlActionRepository);

  @override
  Future<Result<List<ControlAction>>> call(
      GetControlActionsByPhaseIdParams params) {
    return _controlActionRepository
        .getControlActionsByPhaseId(params.cropPhaseId);
  }
}

class GetControlActionsByPhaseIdParams {
  final int cropPhaseId;

  GetControlActionsByPhaseIdParams({required this.cropPhaseId});
}
