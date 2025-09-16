import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crops_data_use_case.dart';
import 'package:mobile_app/utils/result.dart';

class FinishedCropsViewModel extends ChangeNotifier {
  final int growRoomId;
  final GetFinishedCropsDataUseCase _getFinishedCropsDataUseCase;

  FinishedCropsViewModel({
    required this.growRoomId,
    required GetFinishedCropsDataUseCase getFinishedCropsDataUseCase,
  }) : _getFinishedCropsDataUseCase = getFinishedCropsDataUseCase {
    fetchAllData();
    searchController.addListener(_onSearchChanged);
  }

  static const Duration _debounceDuration = Duration(milliseconds: 300);
  Timer? _debounce;

  List<Crop> _allFinishedCrops = [];
  bool _isLoading = true;
  String? _error;
  String _growRoomName = '';
  String _searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get growRoomName => _growRoomName;
  String get searchQuery => _searchQuery;

  List<Crop> get finishedCrops {
    if (_searchQuery.isEmpty) {
      return _allFinishedCrops;
    }
    return _allFinishedCrops
        .where(
            (crop) => crop.id.toString().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getFinishedCropsDataUseCase(growRoomId);

    switch (result) {
      case Success(value: final data):
        _allFinishedCrops = data.finishedCrops;
        _growRoomName = data.growRoomName;
        break;
      case Error(error: final e):
        _error = 'Ocurrió un error al cargar los datos: ${e.toString()}';
        _allFinishedCrops = [];
        _growRoomName = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      setSearchQuery(searchController.text.trim());
    });
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
