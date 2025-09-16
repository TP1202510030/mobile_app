import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';

class CreateCropValidator {
  bool isFrequencyStepValid(Duration frequency) {
    return frequency > Duration.zero;
  }

  bool arePhasesStepValid(List<PhaseState> phases) {
    if (phases.isEmpty) return false;
    return phases.every((p) => p.isDefinitionValid);
  }

  bool areThresholdsStepValid(List<PhaseState> phases) {
    if (phases.isEmpty) return false;
    return phases.every((p) => p.areThresholdsValid);
  }

  bool isStepValid(
      CreateCropStep step, Duration frequency, List<PhaseState> phases) {
    switch (step) {
      case CreateCropStep.frequency:
        return isFrequencyStepValid(frequency);
      case CreateCropStep.phases:
        return arePhasesStepValid(phases);
      case CreateCropStep.thresholds:
        return areThresholdsStepValid(phases);
      case CreateCropStep.confirmation:
        return isFrequencyStepValid(frequency) &&
            arePhasesStepValid(phases) &&
            areThresholdsStepValid(phases);
    }
  }
}
