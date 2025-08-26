class CreateCropRequest {
  final String sensorActivationFrequency;
  final List<CreateCropPhase> phases;

  CreateCropRequest({
    required this.sensorActivationFrequency,
    required this.phases,
  });

  Map<String, dynamic> toJson() => {
        'sensorActivationFrequency': sensorActivationFrequency,
        'phases': phases.map((p) => p.toJson()).toList(),
      };
}

class CreateCropPhase {
  final String name;
  final String phaseDuration;
  final Map<String, double> parameterThresholds;

  CreateCropPhase({
    required this.name,
    required this.phaseDuration,
    required this.parameterThresholds,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phaseDuration': phaseDuration,
        'parameterThresholds': parameterThresholds,
      };
}
