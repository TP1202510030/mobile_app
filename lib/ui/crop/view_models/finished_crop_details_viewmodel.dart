import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
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

  FinishedCropDetails? _data;
  bool _isLoading = true;
  String? _error;
  int _selectedPhaseIndex = 0;

  FinishedCropDetails? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedPhaseIndex => _selectedPhaseIndex;

  Crop? get crop => _data?.crop;
  List<PhaseDetails> get phaseDetails => _data?.phaseDetails ?? [];
  PhaseDetails? get selectedPhaseDetails =>
      phaseDetails.isNotEmpty ? phaseDetails[_selectedPhaseIndex] : null;

  bool get canGoBack => _selectedPhaseIndex > 0;
  bool get canGoForward =>
      _selectedPhaseIndex < (data?.phaseDetails.length ?? 0) - 1;

  Future<void> fetchCropHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getFinishedCropDetailsUseCase(
        GetFinishedCropDetailsParams(cropId: cropId));

    switch (result) {
      case Success(value: final data):
        _data = data;
        break;
      case Error(error: final e):
        _error = 'Ocurrió un error al cargar el historial: ${e.toString()}';
        break;
    }

    _isLoading = false;
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
