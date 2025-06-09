import 'package:flutter/material.dart';
import 'package:mobile_app/data/services/api/model/grow_room/measurement_service.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class CropViewModel extends ChangeNotifier {
  final int cropId;
  final MeasurementService _measurementService;
  int _selectedSectionIndex = 0;

  List<Measurement> _latestMeasurements = [];
  bool _isLoadingMeasurements = false;
  String? _measurementError;

  List<Measurement> get latestMeasurements => _latestMeasurements;
  bool get isLoadingMeasurements => _isLoadingMeasurements;
  String? get measurementError => _measurementError;
  int get selectedSectionIndex => _selectedSectionIndex;

  CropViewModel(this.cropId, this._measurementService) {
    _loadLatestMeasurements();
  }

  void selectSection(int index) {
    if (_selectedSectionIndex != index) {
      _selectedSectionIndex = index;
      notifyListeners();
    }
  }

  Future<void> _loadLatestMeasurements() async {
    _isLoadingMeasurements = true;
    _measurementError = null;
    notifyListeners();

    try {
      final measurements = await _measurementService
          .fetchMeasurementsForCurrentPhaseByGrowRoomId(cropId);

      _latestMeasurements = _groupAndGetLatestMeasurements(measurements);
    } catch (e) {
      _measurementError = 'Failed to load measurements: $e';
      debugPrint('Error loading measurements: $e');
    } finally {
      _isLoadingMeasurements = false;
      notifyListeners();
    }
  }

  List<Measurement> _groupAndGetLatestMeasurements(
      List<Measurement> measurements) {
    final Map<String, Measurement> latestByParameter = {};
    for (var measurement in measurements) {
      if (!latestByParameter.containsKey(measurement.parameter) ||
          measurement.timestamp
              .isAfter(latestByParameter[measurement.parameter]!.timestamp)) {
        latestByParameter[measurement.parameter] = measurement;
      }
    }
    return latestByParameter.values.toList();
  }

  Future<void> refreshMeasurements() async {
    await _loadLatestMeasurements();
  }
}
