import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/data/services/api/model/grow_room/crop_service.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/crop/ui/stepper.dart';

class ThresholdControllers {
  final TextEditingController minController;
  final TextEditingController maxController;

  ThresholdControllers(
      {required this.minController, required this.maxController});

  void dispose() {
    minController.dispose();
    maxController.dispose();
  }
}

class _PhaseViewModel {
  final String id = UniqueKey().toString();
  final VoidCallback _onUpdate;

  late TextEditingController nameController = TextEditingController();
  late TextEditingController durationController = TextEditingController();
  late final Map<Parameter, ThresholdControllers> thresholdControllers;

  _PhaseViewModel({
    String name = '',
    String duration = '',
    required VoidCallback onUpdate,
  }) : _onUpdate = onUpdate {
    nameController = TextEditingController(text: name)..addListener(_onUpdate);
    durationController = TextEditingController(text: duration)
      ..addListener(_onUpdate);
    thresholdControllers = {
      for (var param in Parameter.values)
        param: ThresholdControllers(
          minController: TextEditingController()..addListener(_onUpdate),
          maxController: TextEditingController()..addListener(_onUpdate),
        ),
    };
  }

  void dispose() {
    nameController.removeListener(_onUpdate);
    durationController.removeListener(_onUpdate);
    for (var controllerSet in thresholdControllers.values) {
      controllerSet.minController.removeListener(_onUpdate);
      controllerSet.maxController.removeListener(_onUpdate);
    }

    nameController.dispose();
    durationController.dispose();
    for (var controllerSet in thresholdControllers.values) {
      controllerSet.dispose();
    }
  }
}

class CreateCropViewModel extends ChangeNotifier {
  final int _growRoomId;
  final CropService _cropService;

  CreateCropViewModel(this._growRoomId, this._cropService) {
    _pageController = PageController();
    _steps = [
      StepData(title: 'Frecuencia', isActive: true),
      StepData(title: 'Fases'),
      StepData(title: 'Umbrales'),
      StepData(title: 'Confirmar'),
    ];
    addPhase();
  }

  late final PageController _pageController;
  PageController get pageController => _pageController;

  late final List<StepData> _steps;
  List<StepData> get steps => _steps;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Step 1 Data
  Duration _sensorActivationFrequency = const Duration(hours: 4, minutes: 15);
  Duration get sensorActivationFrequency => _sensorActivationFrequency;

  // Step 2 Data
  final List<_PhaseViewModel> _phases = [];
  List<_PhaseViewModel> get phases => _phases;

  bool get isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return _isStep1Valid();
      case 1:
        return _isStep2Valid();
      case 2:
        return _isStep3Valid();
      case 3: // El paso de confirmación siempre es válido para continuar
        return true;
      default:
        return false;
    }
  }

  bool _isStep1Valid() {
    // La frecuencia es válida si no es cero.
    return sensorActivationFrequency > Duration.zero;
  }

  bool _isStep2Valid() {
    if (phases.isEmpty) return false;
    // Válido si todas las fases tienen nombre y duración.
    return phases.every((phase) =>
        phase.nameController.text.trim().isNotEmpty &&
        phase.durationController.text.trim().isNotEmpty);
  }

  bool _isStep3Valid() {
    if (phases.isEmpty) return false;
    // Válido si para cada fase, todos sus umbrales (min y max) están llenos.
    return phases.every((phase) => phase.thresholdControllers.values.every(
        (controllers) =>
            controllers.minController.text.trim().isNotEmpty &&
            controllers.maxController.text.trim().isNotEmpty));
  }

  void addPhase() {
    // ✅ CAMBIO: Pasamos `notifyListeners` como el callback de actualización.
    _phases.add(_PhaseViewModel(onUpdate: notifyListeners));
    notifyListeners();
  }

  void removePhase(int index) {
    _phases[index].dispose();
    _phases.removeAt(index);
    notifyListeners();
  }

  void updateSensorFrequency(Duration newFrequency) {
    _sensorActivationFrequency = newFrequency;
    notifyListeners();
  }

  void goToStep(int step) {
    if (step >= 0 && step < _steps.length) {
      if (_currentStep != step) {
        _steps[_currentStep].isActive = false;
        _steps[step].isActive = true;
        _currentStep = step;
        _pageController.animateToPage(
          step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    }
  }

  void nextStep(BuildContext context) {
    if (_currentStep < _steps.length - 1) {
      _steps[_currentStep].isCompleted = true;
      goToStep(_currentStep + 1);
    } else {
      createCrop(context);
    }
  }

  void previousStep(BuildContext context) {
    if (_currentStep > 0) {
      _steps[_currentStep].isActive = false;
      _steps[_currentStep - 1].isCompleted = false;
      _steps[_currentStep - 1].isActive = true;
      _currentStep--;
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    } else {
      context.pop();
    }
  }

  String _formatDurationToIso8601(Duration duration) {
    if (duration == Duration.zero) return 'PT0S';
    String result = 'P';
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      result += '${days}D';
    }

    if (hours > 0 || minutes > 0 || seconds > 0) {
      result += 'T';
      if (hours > 0) {
        result += '${hours}H';
      }
      if (minutes > 0) {
        result += '${minutes}M';
      }
      if (seconds > 0) {
        result += '${seconds}S';
      }
    }

    // If only days are present, T might be redundant but is valid.
    // If no time parts, remove T.
    if (result.endsWith('T')) {
      return result.substring(0, result.length - 1);
    }

    return result;
  }

  Future<void> createCrop(BuildContext context) async {
    try {
      final phasesData = _phases.map((phaseVM) {
        final durationInDays =
            int.tryParse(phaseVM.durationController.text) ?? 0;
        final thresholds = <String, Map<String, double>>{};
        phaseVM.thresholdControllers.forEach((param, controllers) {
          final min = double.tryParse(controllers.minController.text) ?? 0.0;
          final max = double.tryParse(controllers.maxController.text) ?? 0.0;
          thresholds['${param.key}Min'] = {'value': min};
          thresholds['${param.key}Max'] = {'value': max};
        });

        final parameterThresholds = {
          for (var entry in thresholds.entries) entry.key: entry.value['value'],
        };

        return {
          'name': phaseVM.nameController.text,
          'phaseDuration':
              _formatDurationToIso8601(Duration(days: durationInDays)),
          'parameterThresholds': parameterThresholds,
        };
      }).toList();

      final cropData = {
        'startDate': DateTime.now().toIso8601String(),
        'endDate': null,
        'sensorActivationFrequency':
            _formatDurationToIso8601(_sensorActivationFrequency),
        'phases': phasesData,
      };

      await _cropService.createCrop(_growRoomId, cropData);

      if (context.mounted) {
        context.go(Routes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cultivo creado exitosamente!')),
        );
      }
    } catch (e) {
      debugPrint('Error creating crop: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el cultivo: $e')),
        );
      }
    }
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
