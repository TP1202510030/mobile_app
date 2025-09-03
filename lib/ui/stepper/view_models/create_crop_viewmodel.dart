import 'package:flutter/foundation.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/mappers/create_crop_mapper.dart';
import 'package:mobile_app/domain/use_cases/crop/create_crop_use_case.dart';
import 'package:mobile_app/domain/validators/create_crop_validator.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/utils/command.dart';

enum CreateCropStep { frequency, phases, thresholds, confirmation }

@immutable
class ThresholdRange {
  final double? min;
  final double? max;

  const ThresholdRange({this.min, this.max});

  bool get isComplete => min != null && max != null;

  String? get validationError {
    if (!isComplete) return 'Se requieren ambos valores.';
    if (min! >= max!) return 'Mínimo debe ser menor que máximo.';
    return null;
  }

  ThresholdRange copyWith({double? min, double? max}) {
    return ThresholdRange(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}

@immutable
class PhaseState {
  final String name;
  final int days;
  final Map<Parameter, ThresholdRange> thresholds;

  const PhaseState({
    required this.name,
    required this.days,
    required this.thresholds,
  });

  bool get isDefinitionValid => name.trim().isNotEmpty && days > 0;

  bool get areThresholdsValid =>
      thresholds.values.every((t) => t.isComplete && t.validationError == null);

  PhaseState copyWith({
    String? name,
    int? days,
    Map<Parameter, ThresholdRange>? thresholds,
  }) {
    return PhaseState(
      name: name ?? this.name,
      days: days ?? this.days,
      thresholds: thresholds ?? this.thresholds,
    );
  }
}

class CreateCropViewModel extends ChangeNotifier {
  final int _growRoomId;
  final CreateCropUseCase _createCropUseCase;
  final CreateCropValidator _validator;
  final CreateCropMapper _mapper;

  bool get isLoading => _createCommand.isRunning;
  String? errorMessage;
  bool isProcessComplete = false;

  late final Command<Crop, CreateCropParams> _createCommand;

  CreateCropViewModel(
    this._growRoomId,
    this._createCropUseCase,
    this._validator,
    this._mapper,
  ) {
    _createCommand = Command<Crop, CreateCropParams>(_createCropUseCase.call)
      ..addListener(_onCreateStatusChanged);

    _phases.add(_initialPhase());
  }

  int get currentStepIndex => _currentStep.index;
  int get totalSteps => CreateCropStep.values.length;
  bool isStepValid(int index) => _validator.isStepValid(
        CreateCropStep.values[index],
        _sensorActivationFrequency,
        _phases,
      );

  Set<int> get completedSteps => {
        for (var i = 0; i < currentStepIndex; i++)
          if (isStepValid(i)) i,
      };

  CreateCropStep _currentStep = CreateCropStep.frequency;
  CreateCropStep get currentStep => _currentStep;

  Duration _sensorActivationFrequency = const Duration(hours: 4);
  Duration get sensorActivationFrequency => _sensorActivationFrequency;

  final List<PhaseState> _phases = [];
  List<PhaseState> get phases => List.unmodifiable(_phases);

  bool get isCurrentStepValid =>
      _validator.isStepValid(_currentStep, _sensorActivationFrequency, _phases);

  void updateSensorFrequency(Duration newFrequency) {
    if (newFrequency <= Duration.zero ||
        _sensorActivationFrequency == newFrequency) {
      return;
    }
    _sensorActivationFrequency = newFrequency;
    notifyListeners();
  }

  void addPhase() {
    _phases.add(PhaseState(
        name: 'Fase ${_phases.length + 1}',
        days: 1,
        thresholds: _emptyThresholds()));
    notifyListeners();
  }

  void removePhase(int index) {
    if (_phases.length <= 1 || index < 0 || index >= _phases.length) return;
    _phases.removeAt(index);
    notifyListeners();
  }

  void updatePhase(int index, {String? name, int? days}) {
    if (index < 0 || index >= _phases.length) return;
    _phases[index] = _phases[index].copyWith(name: name, days: days);
    notifyListeners();
  }

  void updateThreshold(int phaseIndex, Parameter parameter,
      {double? min, double? max}) {
    if (phaseIndex < 0 || phaseIndex >= _phases.length) return;
    final currentPhase = _phases[phaseIndex];
    final currentThreshold =
        currentPhase.thresholds[parameter] ?? const ThresholdRange();

    final newThresholds =
        Map<Parameter, ThresholdRange>.from(currentPhase.thresholds);
    newThresholds[parameter] = currentThreshold.copyWith(min: min, max: max);

    _phases[phaseIndex] = currentPhase.copyWith(thresholds: newThresholds);
    notifyListeners();
  }

  void nextStep() {
    if (!isCurrentStepValid) return;

    final nextIndex = _currentStep.index + 1;
    if (nextIndex < totalSteps) {
      _goToStep(CreateCropStep.values[nextIndex]);
    } else {
      submit();
    }
  }

  void previousStep() {
    final prevIndex = _currentStep.index - 1;
    if (prevIndex >= 0) {
      _goToStep(CreateCropStep.values[prevIndex]);
    }
  }

  void goToStepIndex(int index) {
    if (index < 0 || index >= totalSteps) return;
    _goToStep(CreateCropStep.values[index]);
  }

  Future<void> submit() async {
    if (!isCurrentStepValid || _createCommand.isRunning) return;

    errorMessage = null;
    notifyListeners();

    final params = _mapper.toApiParams(
      growRoomId: _growRoomId,
      sensorActivationFrequency: _sensorActivationFrequency,
      phases: _phases,
    );
    await _createCommand.execute(params);
  }

  void _onCreateStatusChanged() {
    if (_createCommand.isSuccess) {
      isProcessComplete = true;

      locator<HomeViewModel>().fetchInitialGrowRooms();
    } else if (_createCommand.hasError) {
      errorMessage =
          _createCommand.error?.toString() ?? 'Ocurrió un error desconocido.';
    }
    notifyListeners();
  }

  void _goToStep(CreateCropStep step) {
    if (_currentStep == step) return;
    _currentStep = step;
    notifyListeners();
  }

  Map<Parameter, ThresholdRange> _emptyThresholds() {
    return {for (final p in Parameter.values) p: const ThresholdRange()};
  }

  PhaseState _initialPhase() =>
      PhaseState(name: 'Fase 1', days: 1, thresholds: _emptyThresholds());

  @override
  void dispose() {
    _createCommand.removeListener(_onCreateStatusChanged);
    _createCommand.dispose();
    super.dispose();
  }
}
