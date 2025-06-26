import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/data/services/api/model/grow_room/crop_service.dart';
import 'package:mobile_app/domain/models/grow_room/actuator.dart';
import 'package:mobile_app/data/services/api/model/grow_room/control_action_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/measurement_service.dart';
import 'package:mobile_app/domain/models/grow_room/control_action.dart';
import 'package:mobile_app/domain/models/grow_room/crop.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';

class ActiveCropViewModel extends ChangeNotifier {
  final int cropId;
  final MeasurementService _measurementService;
  final ControlActionService _controlActionService;
  final CropService _cropService;

  int _selectedSectionIndex = 0;

  Crop? _crop;
  int _selectedPhaseIndex = 0;

  Map<Parameter, List<Measurement>> _measurementsByParameter = {};
  List<ControlAction> _controlActions = [];

  bool _isLoadingCrop = true;
  String? _error;

  bool _isLoadingMeasurements = false;
  String? _measurementError;

  bool _isLoadingActions = false;
  String? _actionsError;

  ActiveCropViewModel(
    this.cropId,
    this._cropService,
    this._measurementService,
    this._controlActionService,
  ) {
    loadInitialData();
  }

  bool get isLoading => _isLoadingCrop;
  String? get error => _error;

  bool get isLoadingMeasurements => _isLoadingMeasurements;
  String? get measurementError => _measurementError;
  int get selectedSectionIndex => _selectedSectionIndex;

  List<ControlAction> get controlActions => _controlActions;
  bool get isLoadingActions => _isLoadingActions;
  String? get actionsError => _actionsError;

  CropPhase? get selectedPhase => _crop?.phases[_selectedPhaseIndex];
  bool get canGoBack => _selectedPhaseIndex > 0;
  bool get canGoForward =>
      _crop != null && _selectedPhaseIndex < _crop!.phases.length - 1;

  bool get isCurrentActivePhase {
    if (_crop?.currentPhase == null || selectedPhase == null) return false;
    return _crop!.currentPhase!.id == selectedPhase!.id;
  }

  bool get isLastPhase {
    if (_crop == null) return false;
    return _selectedPhaseIndex == _crop!.phases.length - 1;
  }

  Map<Parameter, List<Measurement>> get measurementsByParameter {
    return _measurementsByParameter.map((parameter, fullList) {
      if (fullList.length > 12) {
        final limitedList = fullList.sublist(fullList.length - 12);
        return MapEntry(parameter, limitedList);
      }
      return MapEntry(parameter, fullList);
    });
  }

  Map<Actuator, ControlAction?> get latestActuatorStates {
    final Map<Actuator, ControlAction> latestStates = {};
    for (var action in _controlActions) {
      final actuatorType = ActuatorInfo.fromKey(action.actuatorType);
      if (!latestStates.containsKey(actuatorType) ||
          action.timestamp.isAfter(latestStates[actuatorType]!.timestamp)) {
        latestStates[actuatorType] = action;
      }
    }
    final fullMap = {
      for (var type in Actuator.values) type: latestStates[type]
    };
    return fullMap;
  }

  Map<String, List<ControlAction>> get actionsGroupedByDate {
    final Map<String, List<ControlAction>> grouped = {};
    for (var action in _controlActions) {
      final formattedDate = _formatDateForHeader(action.timestamp.toLocal());
      if (!grouped.containsKey(formattedDate)) {
        grouped[formattedDate] = [];
      }
      grouped[formattedDate]!.add(action);
    }
    return grouped;
  }

  Future<void> _loadMeasurements() async {
    _isLoadingMeasurements = true;
    _measurementError = null;
    notifyListeners();

    try {
      final startTime = DateTime.now();
      final measurements = await _measurementService
          .getMeasurementsForCurrentPhaseByCropId(cropId);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      debugPrint('Tiempo de la llamada a la API: $duration ms');

      _measurementsByParameter = _groupMeasurementsByParameter(measurements);
    } catch (e) {
      _measurementError = 'Failed to load measurements: $e';
      debugPrint('Error loading measurements: $e');
    } finally {
      _isLoadingMeasurements = false;
      notifyListeners();
    }
  }

  Future<void> _loadControlActions() async {
    _isLoadingActions = true;
    _actionsError = null;
    notifyListeners();
    try {
      _controlActions = await _controlActionService
          .getControlActionsForCurrentPhaseByCropId(cropId);
      _controlActions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _actionsError = 'Error al cargar el historial de acciones: $e';
    } finally {
      _isLoadingActions = false;
      notifyListeners();
    }
  }

  String _formatDateForHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Hoy';
    } else if (dateToCompare == yesterday) {
      return 'Ayer';
    } else {
      return DateFormat.yMMMMd('es_ES').format(date);
    }
  }

  Map<Parameter, List<Measurement>> _groupMeasurementsByParameter(
      List<Measurement> measurements) {
    final Map<Parameter, List<Measurement>> groupedData = {};
    for (var measurement in measurements) {
      final parameterEnum = ParameterInfo.fromKey(measurement.parameter);
      if (!groupedData.containsKey(parameterEnum)) {
        groupedData[parameterEnum] = [];
      }
      groupedData[parameterEnum]!.add(measurement);
    }
    groupedData.forEach((key, value) {
      value.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    return groupedData;
  }

  Future<void> refreshMeasurements() async {
    await _loadMeasurements();
  }

  void selectSection(int index) {
    if (_selectedSectionIndex != index) {
      _selectedSectionIndex = index;
      notifyListeners();
    }
  }

  Future<void> loadInitialData() async {
    _isLoadingCrop = true;
    _error = null;
    notifyListeners();
    try {
      _crop = await _cropService.getCropById(cropId);
      if (_crop!.currentPhase != null) {
        _selectedPhaseIndex =
            _crop!.phases.indexWhere((p) => p.id == _crop!.currentPhase!.id);
        if (_selectedPhaseIndex == -1) _selectedPhaseIndex = 0;
      } else {
        _selectedPhaseIndex = 0;
      }
      await _loadDataForSelectedPhase();
    } catch (e) {
      _error = 'Error al cargar el cultivo: $e';
    } finally {
      _isLoadingCrop = false;
      notifyListeners();
    }
  }

  Future<void> _loadDataForSelectedPhase() async {
    final phaseId = selectedPhase?.id;
    if (phaseId == null) return;

    // Cargar mediciones y acciones en paralelo
    _isLoadingMeasurements = true;
    _isLoadingActions = true;
    notifyListeners();

    try {
      final futureMeasurements =
          _measurementService.getMeasurementsByPhaseId(phaseId);
      final futureActions =
          _controlActionService.getControlActionsByPhaseId(phaseId);

      final results = await Future.wait([futureMeasurements, futureActions]);

      final measurements = results[0] as List<Measurement>;
      final actions = results[1] as List<ControlAction>;

      _measurementsByParameter = _groupMeasurementsByParameter(measurements);
      _controlActions = actions;
      _controlActions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _error = 'Error al cargar datos de la fase: $e';
    } finally {
      _isLoadingMeasurements = false;
      _isLoadingActions = false;
      notifyListeners();
    }
  }

  // ✅ NUEVOS MÉTODOS DE PAGINACIÓN
  void goToNextPhase() {
    if (canGoForward) {
      _selectedPhaseIndex++;
      _loadDataForSelectedPhase();
      notifyListeners();
    }
  }

  void goToPreviousPhase() {
    if (canGoBack) {
      _selectedPhaseIndex--;
      _loadDataForSelectedPhase();
      notifyListeners();
    }
  }

  // ✅ NUEVO: Lógica para finalizar la fase
  Future<void> advancePhase() async {
    _isLoadingCrop = true;
    notifyListeners();
    try {
      await _cropService.advanceCropPhase(cropId);
      // Recargar todo para reflejar el nuevo estado del cultivo
      await loadInitialData();
    } catch (e) {
      _error = "Error al finalizar la fase: $e";
    } finally {
      _isLoadingCrop = false;
      notifyListeners();
    }
  }
}
