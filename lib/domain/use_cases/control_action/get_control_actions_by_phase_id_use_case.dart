import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/repositories/control_action_repository.dart';
import 'package:mobile_app/domain/use_cases/use_case.dart';
import 'package:mobile_app/utils/result.dart';

class GetControlActionsByPhaseIdUseCase
    implements
        UseCase<Result<PagedResult<ControlAction>>,
            GetControlActionsByPhaseIdParams> {
  final ControlActionRepository _controlActionRepository;

  GetControlActionsByPhaseIdUseCase(this._controlActionRepository);

  @override
  Future<Result<PagedResult<ControlAction>>> call(
      GetControlActionsByPhaseIdParams params) {
    return _controlActionRepository.getControlActionsByPhaseId(
        params.cropPhaseId, params.page, params.size);
  }
}

class GetControlActionsByPhaseIdParams {
  final int cropPhaseId;
  final int page;
  final int size;

  GetControlActionsByPhaseIdParams({
    required this.cropPhaseId,
    required this.page,
    required this.size,
  });
}
