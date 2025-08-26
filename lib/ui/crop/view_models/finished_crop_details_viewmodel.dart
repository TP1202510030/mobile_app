import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crop_details_use_case.dart';

/// ViewModel para la pantalla de detalles de un cultivo finalizado.
///
/// Utiliza [GetFinishedCropDetailsUseCase] para obtener toda la información histórica
/// del cultivo y la procesa para ser mostrada en la UI.
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

    try {
      final data = await _getFinishedCropDetailsUseCase(cropId);
      _crop = data.crop;
      _allMeasurements = data.allMeasurements;
    } catch (e) {
      _error = 'Ocurrió un error al cargar el historial: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
