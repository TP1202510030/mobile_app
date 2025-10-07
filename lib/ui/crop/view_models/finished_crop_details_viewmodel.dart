import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/data/models/paged_result.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crop_details_use_case.dart';
import 'package:mobile_app/domain/use_cases/measurement/get_measurements_by_phase_id_use_case.dart';
import 'package:mobile_app/utils/result.dart';

class FinishedCropDetailViewModel extends ChangeNotifier {
  final int cropId;
  final GetFinishedCropDetailsUseCase _getFinishedCropDetailsUseCase;
  final GetMeasurementsByPhaseIdUseCase _getMeasurementsByPhaseIdUseCase;

  FinishedCropDetailViewModel({
    required this.cropId,
    required GetFinishedCropDetailsUseCase getFinishedCropDetailsUseCase,
    required GetMeasurementsByPhaseIdUseCase getMeasurementsByPhaseIdUseCase,
  })  : _getFinishedCropDetailsUseCase = getFinishedCropDetailsUseCase,
        _getMeasurementsByPhaseIdUseCase = getMeasurementsByPhaseIdUseCase {
    fetchCropHistory();
  }

  FinishedCropDetails? _data;
  bool _isLoading = true;
  String? _error;
  int _selectedPhaseIndex = 0;

  bool _isFetchingMore = false;
  final Map<int, PagedResult<Measurement>> _measurementsCache = {};
  final Map<int, bool> _hasMoreMeasurements = {};
  final Map<int, int> _measurementsPage = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedPhaseIndex => _selectedPhaseIndex;
  bool get isFetchingMore => _isFetchingMore;

  Crop? get crop => _data?.crop;
  List<PhaseDetails> get phaseDetails => _data?.phaseDetails ?? [];

  PhaseDetails? get selectedPhaseDetails =>
      phaseDetails.isNotEmpty ? phaseDetails[_selectedPhaseIndex] : null;

  List<Measurement> get measurementsForSelectedPhase {
    final phaseId = selectedPhaseDetails?.phase.id;
    if (phaseId == null) return [];
    return _measurementsCache[phaseId]?.content ?? [];
  }

  bool get canGoBack => _selectedPhaseIndex > 0;
  bool get canGoForward =>
      _selectedPhaseIndex < (_data?.phaseDetails.length ?? 0) - 1;

  Future<void> fetchCropHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getFinishedCropDetailsUseCase(
        GetFinishedCropDetailsParams(cropId: cropId));

    switch (result) {
      case Success(value: final data):
        _data = data;
        _initializeCache(data.phaseDetails);
        break;
      case Error(error: final e):
        _error = 'Ocurrió un error al cargar el historial: ${e.toString()}';
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _initializeCache(List<PhaseDetails> details) {
    for (var detail in details) {
      final phaseId = detail.phase.id;
      _measurementsCache[phaseId] = detail.measurements;
      _hasMoreMeasurements[phaseId] = !detail.measurements.isLast;
      _measurementsPage[phaseId] = 0;
    }
  }

  Future<void> fetchMoreMeasurementsForSelectedPhase() async {
    final phaseId = selectedPhaseDetails?.phase.id;
    if (phaseId == null ||
        _isFetchingMore ||
        !(_hasMoreMeasurements[phaseId] ?? false)) {
      return;
    }

    _isFetchingMore = true;
    notifyListeners();

    final nextPage = (_measurementsPage[phaseId] ?? 0) + 1;
    final result = await _getMeasurementsByPhaseIdUseCase(
      GetMeasurementsByPhaseIdParams(
        cropPhaseId: phaseId,
        page: nextPage,
        size: ApiConstants.defaultPageSize,
      ),
    );

    if (result is Success<PagedResult<Measurement>>) {
      final newMeasurements = result.value;
      final existingMeasurements = _measurementsCache[phaseId]?.content ?? [];
      final updatedContent = List<Measurement>.from(existingMeasurements)
        ..addAll(newMeasurements.content);

      _measurementsCache[phaseId] = PagedResult(
        content: updatedContent,
        totalPages: newMeasurements.totalPages,
        totalElements: newMeasurements.totalElements,
        size: newMeasurements.size,
        number: newMeasurements.number,
        isLast: newMeasurements.isLast,
        isFirst: newMeasurements.isFirst,
      );

      _hasMoreMeasurements[phaseId] = !newMeasurements.isLast;
      _measurementsPage[phaseId] = nextPage;
    } else {
      log('Failed to fetch more measurements');
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  void _changePhase(int newIndex) {
    if (newIndex >= 0 && newIndex < phaseDetails.length) {
      _selectedPhaseIndex = newIndex;
      notifyListeners();
    }
  }

  void goToNextPhase() {
    if (canGoForward) _changePhase(_selectedPhaseIndex + 1);
  }

  void goToPreviousPhase() {
    if (canGoBack) _changePhase(_selectedPhaseIndex - 1);
  }
}
