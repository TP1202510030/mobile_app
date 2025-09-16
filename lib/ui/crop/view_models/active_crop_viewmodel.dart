import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/control_action/control_action_type.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/crop/crop_phase.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/domain/use_cases/control_action/get_control_actions_by_phase_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/advance_crop_phase_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/finish_crop_use_case.dart';
import 'package:mobile_app/domain/use_cases/crop/get_crop_details_use_case.dart';
import 'package:mobile_app/domain/use_cases/measurement/get_measurements_by_phase_id_use_case.dart';
import 'package:mobile_app/utils/command.dart';
import 'package:mobile_app/utils/result.dart';

@immutable
sealed class ActiveCropState {
  const ActiveCropState();
}

class ActiveCropLoading extends ActiveCropState {
  const ActiveCropLoading();
}

class ActiveCropError extends ActiveCropState {
  final String message;
  const ActiveCropError(this.message);
}

class ActiveCropSuccess extends ActiveCropState {
  final Crop crop;
  final int selectedPhaseIndex;
  final bool isPhaseDataLoading;
  final Map<int, List<Measurement>> measurementsCache;
  final Map<int, PagedResult<ControlAction>> actionsCache;
  final Map<int, bool> hasMoreActions;
  final Map<int, int> actionsPage;
  final bool isFetchingMoreActions;
  final Map<Actuator, String> actuatorStates;

  const ActiveCropSuccess({
    required this.crop,
    required this.selectedPhaseIndex,
    this.isPhaseDataLoading = false,
    this.measurementsCache = const {},
    this.actionsCache = const {},
    this.hasMoreActions = const {},
    this.actionsPage = const {},
    this.isFetchingMoreActions = false,
    this.actuatorStates = const {},
  });

  CropPhase get selectedPhase => crop.phases[selectedPhaseIndex];
  List<Measurement> get measurementsForSelectedPhase =>
      measurementsCache[selectedPhase.id] ?? [];
  List<ControlAction> get actionsForSelectedPhase =>
      actionsCache[selectedPhase.id]?.content ?? [];

  bool get canGoBack => selectedPhaseIndex > 0;
  bool get canGoForward => selectedPhaseIndex < crop.phases.length - 1;
  bool get isCurrentActivePhase => crop.currentPhase?.id == selectedPhase.id;
  bool get isLastPhase => selectedPhaseIndex == crop.phases.length - 1;

  ActiveCropSuccess copyWith({
    Crop? crop,
    int? selectedPhaseIndex,
    bool? isPhaseDataLoading,
    Map<int, List<Measurement>>? measurementsCache,
    Map<int, PagedResult<ControlAction>>? actionsCache,
    Map<int, bool>? hasMoreActions,
    Map<int, int>? actionsPage,
    bool? isFetchingMoreActions,
    Map<Actuator, String>? actuatorStates,
  }) {
    return ActiveCropSuccess(
      crop: crop ?? this.crop,
      selectedPhaseIndex: selectedPhaseIndex ?? this.selectedPhaseIndex,
      isPhaseDataLoading: isPhaseDataLoading ?? this.isPhaseDataLoading,
      measurementsCache: measurementsCache ?? this.measurementsCache,
      actionsCache: actionsCache ?? this.actionsCache,
      hasMoreActions: hasMoreActions ?? this.hasMoreActions,
      actionsPage: actionsPage ?? this.actionsPage,
      isFetchingMoreActions:
          isFetchingMoreActions ?? this.isFetchingMoreActions,
      actuatorStates: actuatorStates ?? this.actuatorStates,
    );
  }
}

class _PhaseDataProcessor {
  static Map<Parameter, List<Measurement>> groupMeasurements(
      List<Measurement> measurements) {
    final groupedData = <Parameter, List<Measurement>>{};
    for (var m in measurements) {
      (groupedData[m.parameter] ??= []).add(m);
    }
    groupedData.forEach(
        (_, value) => value.sort((a, b) => a.timestamp.compareTo(b.timestamp)));
    return groupedData;
  }

  static Map<String, List<ControlAction>> groupActionsByDate(
      List<ControlAction> actions) {
    final grouped = <String, List<ControlAction>>{};
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
  final GetCropDetailsUseCase _getCropDetailsUseCase;
  final GetMeasurementsByPhaseIdUseCase _getMeasurementsUseCase;
  final GetControlActionsByPhaseIdUseCase _getControlActionsUseCase;
  final AdvanceCropPhaseUseCase _advanceCropPhaseUseCase;
  final FinishCropUseCase _finishCropUseCase;

  ActiveCropState _state = const ActiveCropLoading();
  ActiveCropState get state => _state;

  int _selectedSectionIndex = 0;
  int get selectedSectionIndex => _selectedSectionIndex;

  late final Command<void, double> finishCropCommand;

  Map<Parameter, List<Measurement>> get measurementsByParameter {
    if (_state is ActiveCropSuccess) {
      return _PhaseDataProcessor.groupMeasurements(
          (_state as ActiveCropSuccess).measurementsForSelectedPhase);
    }
    return {};
  }

  // Getter nuevo y correcto
  Map<Actuator, ControlActionType> get currentActuatorStates {
    if (_state is! ActiveCropSuccess) return {};

    final successState = _state as ActiveCropSuccess;
    return successState.actuatorStates.map(
      (key, value) => MapEntry(key, ControlActionTypeData.fromKey(value)),
    );
  }

  Map<String, List<ControlAction>> get actionsGroupedByDate {
    if (_state is ActiveCropSuccess) {
      return _PhaseDataProcessor.groupActionsByDate(
          (_state as ActiveCropSuccess).actionsForSelectedPhase);
    }
    return {};
  }

  ActiveCropViewModel({
    required this.cropId,
    required GetCropDetailsUseCase getCropDetailsUseCase,
    required GetMeasurementsByPhaseIdUseCase getMeasurementsUseCase,
    required GetControlActionsByPhaseIdUseCase getControlActionsUseCase,
    required AdvanceCropPhaseUseCase advanceCropPhaseUseCase,
    required FinishCropUseCase finishCropUseCase,
  })  : _getCropDetailsUseCase = getCropDetailsUseCase,
        _getMeasurementsUseCase = getMeasurementsUseCase,
        _getControlActionsUseCase = getControlActionsUseCase,
        _advanceCropPhaseUseCase = advanceCropPhaseUseCase,
        _finishCropUseCase = finishCropUseCase {
    finishCropCommand = Command<void, double>(_finishCropInternal);
    refreshData();
  }

  Future<void> refreshData() async {
    _state = const ActiveCropLoading();
    notifyListeners();

    final result =
        await _getCropDetailsUseCase(GetCropDetailsParams(cropId: cropId));

    switch (result) {
      case Success(value: final details):
        final currentPhaseIndex = details.crop.phases
            .indexWhere((p) => p.id == (details.crop.currentPhase?.id ?? -1));

        _state = ActiveCropSuccess(
          crop: details.crop,
          selectedPhaseIndex: currentPhaseIndex != -1 ? currentPhaseIndex : 0,
          actuatorStates: details.actuatorStates,
        );

        notifyListeners();
        _loadDataForSelectedPhase();
        break;
      case Error(error: final e):
        _state = ActiveCropError('Error al cargar el cultivo: ${e.toString()}');
        notifyListeners();
        break;
    }
  }

  // ... (el resto del archivo permanece igual)
  Future<void> _loadDataForSelectedPhase() async {
    if (_state is! ActiveCropSuccess) return;
    final successState = _state as ActiveCropSuccess;
    final phaseId = successState.selectedPhase.id;

    if (successState.measurementsCache.containsKey(phaseId) &&
        successState.actionsCache.containsKey(phaseId)) {
      return;
    }

    _state = successState.copyWith(isPhaseDataLoading: true);
    notifyListeners();

    try {
      final results = await Future.wait([
        _getMeasurementsUseCase(
            GetMeasurementsByPhaseIdParams(cropPhaseId: phaseId)),
        _getControlActionsUseCase(GetControlActionsByPhaseIdParams(
          cropPhaseId: phaseId,
          page: 0,
          size: ApiConstants.defaultPageSize,
        )),
      ]);

      final measurementsResult = results[0] as Result<List<Measurement>>;
      final actionsResult = results[1] as Result<PagedResult<ControlAction>>;

      if (_state is! ActiveCropSuccess) return;
      final currentSuccessState = _state as ActiveCropSuccess;

      var newMeasurementsCache = Map<int, List<Measurement>>.from(
          currentSuccessState.measurementsCache);
      var newActionsCache = Map<int, PagedResult<ControlAction>>.from(
          currentSuccessState.actionsCache);
      final newHasMoreActions =
          Map<int, bool>.from(currentSuccessState.hasMoreActions);
      final newActionsPage =
          Map<int, int>.from(currentSuccessState.actionsPage);

      switch (measurementsResult) {
        case Success(value: final measurements):
          newMeasurementsCache[phaseId] = measurements;
        case Error(error: final e):
          developer.log('Error al cargar mediciones: $e');
      }

      switch (actionsResult) {
        case Success(value: final pagedResult):
          newActionsCache[phaseId] = pagedResult;
          newHasMoreActions[phaseId] = !pagedResult.isLast;
          newActionsPage[phaseId] = 0;

        case Error(error: final e):
          developer.log('Error al cargar acciones de control: $e');
      }

      _state = currentSuccessState.copyWith(
        isPhaseDataLoading: false,
        measurementsCache: newMeasurementsCache,
        actionsCache: newActionsCache,
        hasMoreActions: newHasMoreActions,
        actionsPage: newActionsPage,
      );
    } catch (e) {
      developer.log('Error inesperado en _loadDataForSelectedPhase: $e');
      if (_state is ActiveCropSuccess) {
        _state =
            (_state as ActiveCropSuccess).copyWith(isPhaseDataLoading: false);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMoreActionsForSelectedPhase() async {
    if (_state is! ActiveCropSuccess) return;
    final successState = _state as ActiveCropSuccess;

    final phaseId = successState.selectedPhase.id;
    final hasMore = successState.hasMoreActions[phaseId] ?? false;
    if (successState.isFetchingMoreActions || !hasMore) return;

    _state = successState.copyWith(isFetchingMoreActions: true);
    notifyListeners();

    final nextPage = (successState.actionsPage[phaseId] ?? 0) + 1;

    final result = await _getControlActionsUseCase(
      GetControlActionsByPhaseIdParams(
        cropPhaseId: phaseId,
        page: nextPage,
        size: ApiConstants.defaultPageSize,
      ),
    );

    if (_state is! ActiveCropSuccess) return;

    final currentSuccessState = _state as ActiveCropSuccess;

    var newActionsCache = Map<int, PagedResult<ControlAction>>.from(
        currentSuccessState.actionsCache);
    final newHasMoreActions =
        Map<int, bool>.from(currentSuccessState.hasMoreActions);
    final newActionsPage = Map<int, int>.from(currentSuccessState.actionsPage);

    switch (result) {
      case Success(value: final pagedResult):
        final currentPagedResult = newActionsCache[phaseId];
        if (currentPagedResult != null) {
          final updatedContent =
              List<ControlAction>.from(currentPagedResult.content)
                ..addAll(pagedResult.content);

          newActionsCache[phaseId] = PagedResult(
            content: updatedContent,
            totalPages: pagedResult.totalPages,
            totalElements: pagedResult.totalElements,
            size: pagedResult.size,
            number: pagedResult.number,
            isLast: pagedResult.isLast,
            isFirst: pagedResult.isFirst,
          );
        } else {
          newActionsCache[phaseId] = pagedResult;
        }
        newHasMoreActions[phaseId] = !pagedResult.isLast;
        newActionsPage[phaseId] = nextPage;

      case Error(error: final e):
        developer.log('Error al cargar más acciones de control: $e');
    }

    _state = currentSuccessState.copyWith(
      isFetchingMoreActions: false,
      actionsCache: newActionsCache,
      hasMoreActions: newHasMoreActions,
      actionsPage: newActionsPage,
    );
    notifyListeners();
  }

  Future<void> advancePhase() async {
    _state = const ActiveCropLoading();
    notifyListeners();
    final result =
        await _advanceCropPhaseUseCase(AdvanceCropPhaseParams(cropId: cropId));
    if (result is Error) {
      developer.log('Error al avanzar de fase: ${result.error.toString()}');
      await refreshData();
    } else {
      await refreshData();
    }
  }

  Future<Result<void>> _finishCropInternal(double totalProduction) async {
    if (_state is! ActiveCropSuccess) {
      return Result.error(
          Exception("No se puede finalizar el cultivo en un estado inválido."));
    }

    final previousState = _state;
    _state = const ActiveCropLoading();
    notifyListeners();

    final result = await _finishCropUseCase(
        FinishCropParams(cropId: cropId, totalProduction: totalProduction));

    _state = previousState;
    notifyListeners();

    return result;
  }

  void selectSection(int index) {
    if (_selectedSectionIndex != index) {
      _selectedSectionIndex = index;
      notifyListeners();
    }
  }

  void _changePhase(int newIndex) {
    if (_state is! ActiveCropSuccess) return;
    final successState = _state as ActiveCropSuccess;

    _state = successState.copyWith(selectedPhaseIndex: newIndex);
    notifyListeners();
    _loadDataForSelectedPhase();
  }

  void goToNextPhase() {
    if (_state is ActiveCropSuccess) {
      final s = _state as ActiveCropSuccess;
      if (s.canGoForward) _changePhase(s.selectedPhaseIndex + 1);
    }
  }

  void goToPreviousPhase() {
    if (_state is ActiveCropSuccess) {
      final s = _state as ActiveCropSuccess;
      if (s.canGoBack) _changePhase(s.selectedPhaseIndex - 1);
    }
  }
}
