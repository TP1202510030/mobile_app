import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/domain/use_cases/crop/create_crop_use_case.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';

class CreateCropMapper {
  CreateCropParams toApiParams({
    required int growRoomId,
    required Duration sensorActivationFrequency,
    required List<PhaseState> phases,
  }) {
    final phaseParams = phases.map((phase) {
      final thresholds = <String, double>{};
      phase.thresholds.forEach((param, range) {
        if (range.isComplete) {
          final keyBase = _camelCaseFromSnakeCase(param.key);
          thresholds['${keyBase}Min'] = range.min!;
          thresholds['${keyBase}Max'] = range.max!;
        }
      });
      return CreateCropPhaseParams(
        name: phase.name,
        phaseDuration: 'PT${phase.days * 24}H',
        parameterThresholds: thresholds,
      );
    }).toList();

    return CreateCropParams(
      growRoomId: growRoomId,
      sensorActivationFrequency: _toIso8601Duration(sensorActivationFrequency),
      phases: phaseParams,
    );
  }

  String _toIso8601Duration(Duration d) {
    return 'PT${d.inHours}H${d.inMinutes.remainder(60)}M';
  }

  String _camelCaseFromSnakeCase(String snakeCase) {
    final parts = snakeCase.split('_');
    if (parts.isEmpty) return '';
    final firstWord = parts.first.toLowerCase();
    final remainingWords = parts
        .skip(1)
        .map((word) => word.isNotEmpty
            ? '${word[0]}${word.substring(1).toLowerCase()}'
            : '')
        .join();
    return '$firstWord$remainingWords';
  }
}
