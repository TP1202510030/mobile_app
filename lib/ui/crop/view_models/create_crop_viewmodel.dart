import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/domain/use_cases/crop/create_crop_use_case.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/crop/ui/stepper.dart';

class ThresholdControllers {
  final TextEditingController minController;
  final TextEditingController maxController;

  ThresholdControllers({String min = '', String max = ''})
      : minController = TextEditingController(text: min),
        maxController = TextEditingController(text: max);

  void dispose() {
    minController.dispose();
    maxController.dispose();
  }
}

class PhaseViewModel {
  final String id = UniqueKey().toString();
  final VoidCallback _onUpdate;

  late final TextEditingController nameController;
  late final TextEditingController durationController;
  late final Map<Parameter, ThresholdControllers> thresholdControllers;

  PhaseViewModel({
    String name = '',
    String duration = '',
    required VoidCallback onUpdate,
  }) : _onUpdate = onUpdate {
    nameController = TextEditingController(text: name)..addListener(_onUpdate);
    durationController = TextEditingController(text: duration)
      ..addListener(_onUpdate);
    thresholdControllers = {
      for (var param in Parameter.values)
        param: ThresholdControllers()
          ..minController.addListener(_onUpdate)
          ..maxController.addListener(_onUpdate),
    };
  }

  void dispose() {
    nameController.removeListener(_onUpdate);
    durationController.removeListener(_onUpdate);
    for (var controllerSet in thresholdControllers.values) {
      controllerSet.minController.removeListener(_onUpdate);
      controllerSet.maxController.removeListener(_onUpdate);
      controllerSet.dispose();
    }
    nameController.dispose();
    durationController.dispose();
  }
}

class CreateCropViewModel extends ChangeNotifier {
  final int _growRoomId;
  final CreateCropUseCase _createCropUseCase;

  CreateCropViewModel(this._growRoomId, this._createCropUseCase) {
    _pageController = PageController();
    _steps = [
      StepData(title: 'Frecuencia', isActive: true),
      StepData(title: 'Fases'),
      StepData(title: 'Umbrales'),
      StepData(title: 'Confirmar'),
    ];

    addPhase(name: 'Fase 1');
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late final PageController _pageController;
  PageController get pageController => _pageController;
  late final List<StepData> _steps;
  List<StepData> get steps => _steps;
  int _currentStep = 0;
  int get currentStep => _currentStep;

  Duration _sensorActivationFrequency = const Duration(hours: 4);
  Duration get sensorActivationFrequency => _sensorActivationFrequency;
  final List<PhaseViewModel> _phases = [];
  List<PhaseViewModel> get phases => _phases;

  bool get isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return _sensorActivationFrequency > Duration.zero;
      case 1:
        return _phases.every((p) =>
            p.nameController.text.trim().isNotEmpty &&
            p.durationController.text.trim().isNotEmpty);
      case 2:
        return _phases.every((p) => p.thresholdControllers.values.every((c) =>
            getThresholdErrorText(c) == null &&
            c.minController.text.isNotEmpty &&
            c.maxController.text.isNotEmpty));
      case 3:
        return true;
      default:
        return false;
    }
  }

  String? getThresholdErrorText(ThresholdControllers controllers) {
    final minText = controllers.minController.text.trim();
    final maxText = controllers.maxController.text.trim();
    if (minText.isEmpty || maxText.isEmpty) return null;
    final minVal = double.tryParse(minText);
    final maxVal = double.tryParse(maxText);
    if (minVal == null || maxVal == null) return "Valor inválido";
    if (minVal >= maxVal) return 'Min > Max';
    return null;
  }

  void addPhase({String name = ''}) {
    _phases.add(PhaseViewModel(name: name, onUpdate: notifyListeners));
    notifyListeners();
  }

  void removePhase(int index) {
    if (_phases.length > 1) {
      _phases[index].dispose();
      _phases.removeAt(index);
      notifyListeners();
    }
  }

  void updateSensorFrequency(Duration newFrequency) {
    if (_sensorActivationFrequency != newFrequency) {
      _sensorActivationFrequency = newFrequency;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < _steps.length && _currentStep != step) {
      _steps[_currentStep].isActive = false;
      _steps[step].isActive = true;
      _currentStep = step;
      _pageController.animateToPage(step,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      notifyListeners();
    }
  }

  void nextStep(BuildContext context) {
    if (_currentStep < _steps.length - 1) {
      _steps[_currentStep].isCompleted = true;
      goToStep(_currentStep + 1);
    } else {
      _submitCropCreation(context);
    }
  }

  void previousStep(BuildContext context) {
    if (_currentStep > 0) {
      goToStep(_currentStep - 1);
    } else {
      context.pop();
    }
  }

  Future<void> _submitCropCreation(BuildContext context) async {
    if (!isCurrentStepValid) return;

    _isLoading = true;
    notifyListeners();

    try {/*
      final cropData = _buildCropDataPayload();
      await _createCropUseCase(
          CreateCropParams(growRoomId: _growRoomId, cropData: cropData));

      if (context.mounted) {
        context.go(Routes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cultivo creado exitosamente!')),
        );
      }*/
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el cultivo: ${e.toString()}')),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _buildCropDataPayload() {
    String formatDuration(Duration d) =>
        'PT${d.inHours}H${d.inMinutes.remainder(60)}M${d.inSeconds.remainder(60)}S';

    final phasesData = _phases.map((phaseVM) {
      final durationInDays = int.tryParse(phaseVM.durationController.text) ?? 0;
      final parameterThresholds = {
        for (var entry in phaseVM.thresholdControllers.entries) ...{
          '${entry.key.key}Min':
              double.tryParse(entry.value.minController.text) ?? 0.0,
          '${entry.key.key}Max':
              double.tryParse(entry.value.maxController.text) ?? 0.0,
        }
      };
      return {
        'name': phaseVM.nameController.text,
        'duration': 'P${durationInDays}D',
        'thresholds': parameterThresholds,
      };
    }).toList();

    return {
      'sensorActivationFrequency': formatDuration(_sensorActivationFrequency),
      'phases': phasesData,
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var phase in _phases) {
      phase.dispose();
    }
    super.dispose();
  }
}
