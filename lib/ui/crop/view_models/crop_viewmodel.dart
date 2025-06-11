import 'package:flutter/material.dart';
import 'package:mobile_app/data/services/api/model/grow_room/measurement_service.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class CropViewModel extends ChangeNotifier {
  final int cropId;
  final MeasurementService _measurementService;
  int _selectedSectionIndex = 0;

  Map<String, List<Measurement>> _measurementsByParameter = {};

  bool _isLoadingMeasurements = false;
  String? _measurementError;

  Map<String, List<Measurement>> get measurementsByParameter =>
      _measurementsByParameter;
  bool get isLoadingMeasurements => _isLoadingMeasurements;
  String? get measurementError => _measurementError;
  int get selectedSectionIndex => _selectedSectionIndex;

  CropViewModel(this.cropId, this._measurementService) {
    _loadMeasurements();
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

  Map<String, List<Measurement>> _groupMeasurementsByParameter(
      List<Measurement> measurements) {
    final Map<String, List<Measurement>> groupedData = {};
    for (var measurement in measurements) {
      if (!groupedData.containsKey(measurement.parameter)) {
        groupedData[measurement.parameter] = [];
      }
      groupedData[measurement.parameter]!.add(measurement);
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
