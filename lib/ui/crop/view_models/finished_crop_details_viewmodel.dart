import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crop_details_use_case.dart';
import 'package:mobile_app/utils/result.dart';

class FinishedCropDetailViewModel extends ChangeNotifier {
  final int cropId;
  final GetFinishedCropDetailsUseCase _getFinishedCropDetailsUseCase;

  FinishedCropDetailViewModel({
    required this.cropId,
    required GetFinishedCropDetailsUseCase getFinishedCropDetailsUseCase,
  }) : _getFinishedCropDetailsUseCase = getFinishedCropDetailsUseCase {
    fetchCropHistory();
  }

  Crop? _crop;
  List<Measurement> _allMeasurements = [];
  bool _isLoading = true;
  String? _error;

  Crop? get crop => _crop;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<DateTime, List<Measurement>> get measurementsByDate {
    if (_allMeasurements.isEmpty) return {};

    final Map<DateTime, List<Measurement>> groupedMap = {};
    for (final measurement in _allMeasurements) {
      final dateKey = DateUtils.dateOnly(measurement.timestamp.toLocal());
      (groupedMap[dateKey] ??= []).add(measurement);
    }

    return groupedMap;
  }

  Future<void> fetchCropHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getFinishedCropDetailsUseCase(
        GetFinishedCropDetailsParams(cropId: cropId));

    switch (result) {
      case Success(value: final data):
        _crop = data.crop;
        _allMeasurements =
            data.phaseDetails.expand((detail) => detail.measurements).toList();
        break;
      case Error(error: final e):
        _error = 'Ocurrió un error al cargar el historial: ${e.toString()}';
        break;
    }

    _isLoading = false;
    notifyListeners();
  }
}
