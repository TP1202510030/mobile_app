/*
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/domain/use_cases/crop/advance_crop_phase_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/finish_crop_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_active_crop_data_use_case.dart';
import 'package:mobile_app/domain/use_cases/control_action/get_control_actions_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/measurement/get_measurements_by_phase_id_use_case.dart';

class _PhaseDataProcessor {
  static Map<Parameter, List<Measurement>> groupMeasurements(
      List<Measurement> measurements) {
    final Map<Parameter, List<Measurement>> groupedData = {};
    for (var m in measurements) {
      try {
        final key = ParameterData.fromKey(m.parameter);
        (groupedData[key] ??= []).add(m);
      } catch (e) {
        developer.log("Parámetro desconocido omitido: ${m.parameter}");
      }
    }
    groupedData.forEach(
        (_, value) => value.sort((a, b) => a.timestamp.compareTo(b.timestamp)));
    return groupedData;
  }

  static Map<Actuator, ControlAction?> getLatestActuatorStates(
      List<ControlAction> actions) {
    final Map<Actuator, ControlAction> latest = {};
    for (var action in actions) {
      try {
        final type = ActuatorData.fromKey(action.actuatorType);
        if (!latest.containsKey(type) ||
            action.timestamp.isAfter(latest[type]!.timestamp)) {
          latest[type] = action;
        }
      } catch (e) {
        developer.log("Actuador desconocido omitido: ${action.actuatorType}");
      }
    }
    return {for (var type in Actuator.values) type: latest[type]};
  }

  static Map<String, List<ControlAction>> groupActionsByDate(
      List<ControlAction> actions) {
    final Map<String, List<ControlAction>> grouped = {};
    final sortedActions = List<ControlAction>.from(actions)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    for (var action in sortedActions) {
      final dateKey = _formatDateHeader(action.timestamp.toLocal());
      (grouped[dateKey] ??= []).add(action);
    }
    return grouped;
  }

  static String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);
    if (dateToCompare == today) return 'Hoy';
    if (dateToCompare == yesterday) return 'Ayer';
    return DateFormat.yMMMMd('es_ES').format(date);
  }
}

class ActiveCropViewModel extends ChangeNotifier {
  final int cropId;
  final GetActiveCropDataUseCase _getActiveCropDataUseCase;
  final GetMeasurementsForPhaseUseCase _getMeasurementsUseCase;
  final GetControlActionsForPhaseUseCase _getControlActionsUseCase;
  final AdvanceCropPhaseUseCase _advanceCropPhaseUseCase;
  final FinishCropUseCase _finishCropUseCase;

  ActiveCropViewModel({
    required this.cropId,
    required GetActiveCropDataUseCase getActiveCropDataUseCase,
    required GetMeasurementsForPhaseUseCase getMeasurementsUseCase,
    required GetControlActionsForPhaseUseCase getControlActionsUseCase,
    required AdvanceCropPhaseUseCase advanceCropPhaseUseCase,
    required FinishCropUseCase finishCropUseCase,
  })  : _getActiveCropDataUseCase = getActiveCropDataUseCase,
        _getMeasurementsUseCase = getMeasurementsUseCase,
        _getControlActionsUseCase = getControlActionsUseCase,
        _advanceCropPhaseUseCase = advanceCropPhaseUseCase,
        _finishCropUseCase = finishCropUseCase {
    _loadInitialCropStructure();
  }

  bool _isScreenLoading = true;
  bool get isScreenLoading => _isScreenLoading;
  String? _error;
  String? get error => _error;

  bool _isPhaseDataLoading = false;
  bool get isPhaseDataLoading => _isPhaseDataLoading;
  String? _phaseDataError;
  String? get phaseDataError => _phaseDataError;

  Crop? _crop;
  final Map<int, List<Measurement>> _measurementsCache = {};
  final Map<int, List<ControlAction>> _actionsCache = {};

  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;
  int _selectedPhaseIndex = 0;

  CropPhase? get selectedPhase {
    final crop = _crop;
    if (crop == null || crop.phases.length <= _selectedPhaseIndex) {
      return null;
    }
    return crop.phases[_selectedPhaseIndex];
  }

  List<Measurement> get _measurementsForSelectedPhase =>
      _measurementsCache[selectedPhase?.id] ?? [];
  List<ControlAction> get _actionsForSelectedPhase =>
      _actionsCache[selectedPhase?.id] ?? [];

  Map<Parameter, List<Measurement>> get measurementsByParameter =>
      _PhaseDataProcessor.groupMeasurements(_measurementsForSelectedPhase);
  Map<Actuator, ControlAction?> get latestActuatorStates =>
      _PhaseDataProcessor.getLatestActuatorStates(_actionsForSelectedPhase);
  Map<String, List<ControlAction>> get actionsGroupedByDate =>
      _PhaseDataProcessor.groupActionsByDate(_actionsForSelectedPhase);

  bool get canGoBack => _selectedPhaseIndex > 0;
  bool get canGoForward =>
      _crop != null && _selectedPhaseIndex < _crop!.phases.length - 1;
  bool get isCurrentActivePhase => _crop?.currentPhase?.id == selectedPhase?.id;
  bool get isLastPhase =>
      _crop != null && _selectedPhaseIndex == _crop!.phases.length - 1;

  Future<void> _loadInitialCropStructure() async {
    _isScreenLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _getActiveCropDataUseCase(cropId);
      // CORRECCIÓN: Asignar las propiedades del DTO a las variables correctas.
      _crop = data.crop;

      final currentPhaseId = _crop?.currentPhase?.id;
      if (currentPhaseId != null) {
        _selectedPhaseIndex =
            _crop!.phases.indexWhere((p) => p.id == currentPhaseId);
        if (_selectedPhaseIndex == -1) _selectedPhaseIndex = 0;
      }
      await _loadDataForSelectedPhase();
    } catch (e) {
      _error = 'Error al cargar el cultivo: $e';
    } finally {
      _isScreenLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDataForSelectedPhase() async {
    final phaseId = selectedPhase?.id;
    if (phaseId == null || _measurementsCache.containsKey(phaseId)) {
      return;
    }
    _isPhaseDataLoading = true;
    _phaseDataError = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _getMeasurementsUseCase(phaseId),
        _getControlActionsUseCase(phaseId),
      ]);

      _measurementsCache[phaseId] = results[0] as List<Measurement>;
      _actionsCache[phaseId] = results[1] as List<ControlAction>;
    } catch (e) {
      _phaseDataError = 'Error al cargar datos de la fase: $e';
    } finally {
      _isPhaseDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> advancePhase() async {
    _isScreenLoading = true;
    notifyListeners();
    try {
      await _advanceCropPhaseUseCase(cropId);
      _measurementsCache.clear();
      _actionsCache.clear();
      await _loadInitialCropStructure();
    } catch (e) {
      _error = 'Error al avanzar de fase: $e';
    } finally {
      _isScreenLoading = false;
      notifyListeners();
    }
  }

  Future<bool> finishCrop(double totalProduction) async {
    _isScreenLoading = true;
    notifyListeners();
    try {
      await _finishCropUseCase(
          FinishCropParams(cropId: cropId, totalProduction: totalProduction));
      return true;
    } catch (e) {
      _error = 'Error al finalizar el cultivo: $e';
      _isScreenLoading = false;
      notifyListeners();
      return false;
    }
  }

  void selectSection(int index) {
    if (_selectedSectionIndex != index) {
      _selectedSectionIndex = index;
      notifyListeners();
    }
  }

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
}
*/