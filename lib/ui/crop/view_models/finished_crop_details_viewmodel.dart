import 'package:flutter/material.dart';
// No se necesita 'package:collection/collection.dart'
import 'package:mobile_app/data/services/api/model/grow_room/crop_service.dart';
import 'package:mobile_app/domain/models/grow_room/crop.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class FinishedCropDetailViewModel extends ChangeNotifier {
  final int cropId;
  final CropService _cropService;

  Crop? _crop;
  bool _isLoading = true;
  String? _error;

  Crop? get crop => _crop;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<DateTime, List<Measurement>> get measurementsByDate {
    if (_crop == null) return {};

    final allMeasurements =
        _crop!.phases.expand((phase) => phase.measurements).toList();

    final Map<DateTime, List<Measurement>> groupedMap = {};

    for (final measurement in allMeasurements) {
      final dateKey = DateTime(
        measurement.timestamp.year,
        measurement.timestamp.month,
        measurement.timestamp.day,
      );
      groupedMap.putIfAbsent(dateKey, () => []).add(measurement);
    }

    return groupedMap;
  }

  FinishedCropDetailViewModel(
      {required this.cropId, required CropService cropService})
      : _cropService = cropService {
    fetchCropHistory();
  }

  Future<void> fetchCropHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _crop = await _cropService.getCropById(cropId);
    } catch (e) {
      debugPrint('Error fetching crop history: $e');
      _error = 'Ocurrió un error al cargar el historial.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
