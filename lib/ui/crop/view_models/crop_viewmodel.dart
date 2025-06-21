import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/data/services/api/model/grow_room/actuator.dart';
import 'package:mobile_app/data/services/api/model/grow_room/control_action_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/measurement_service.dart';
import 'package:mobile_app/domain/models/grow_room/control_action.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';

class CropViewModel extends ChangeNotifier {
  final int cropId;
  final MeasurementService _measurementService;
  final ControlActionService _controlActionService;

  int _selectedSectionIndex = 0;

  Map<Parameter, List<Measurement>> _measurementsByParameter = {};
  bool _isLoadingMeasurements = false;
  String? _measurementError;

  List<ControlAction> _controlActions = [];
  bool _isLoadingActions = false;
  String? _actionsError;

  Map<Parameter, List<Measurement>> get measurementsByParameter =>
      _measurementsByParameter;
  bool get isLoadingMeasurements => _isLoadingMeasurements;
  String? get measurementError => _measurementError;
  int get selectedSectionIndex => _selectedSectionIndex;

  List<ControlAction> get controlActions => _controlActions;
  bool get isLoadingActions => _isLoadingActions;
  String? get actionsError => _actionsError;

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
      final formattedDate = _formatDateForHeader(action.timestamp);
      if (!grouped.containsKey(formattedDate)) {
        grouped[formattedDate] = [];
      }
      grouped[formattedDate]!.add(action);
    }
    return grouped;
  }

  CropViewModel(
      this.cropId, this._measurementService, this._controlActionService) {
    _loadMeasurements();
    _loadControlActions();
  }

  void selectSection(int index) {
    if (_selectedSectionIndex != index) {
      _selectedSectionIndex = index;
      notifyListeners();
    }
  }

  Future<void> _loadMeasurements() async {
    _isLoadingMeasurements = true;
    _measurementError = null;
    notifyListeners();

    try {
      final startTime = DateTime.now();
      final measurements = await _measurementService
          .fetchMeasurementsForCurrentPhaseByGrowRoomId(cropId);
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
      _controlActions =
          await _controlActionService.getControlActionsForCurrentPhase(cropId);
      // Ordenamos por fecha descendente para la vista de historial
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
      // Usamos el paquete `intl` para un formato localizado y legible.
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
}
