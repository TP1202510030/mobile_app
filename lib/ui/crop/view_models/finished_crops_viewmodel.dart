import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/domain/use_cases/crop/get_finished_crops_by_grow_room_id_use_case.dart';

class FinishedCropsViewModel extends ChangeNotifier {
  final int growRoomId;
  //final GetFinishedCropsDataUseCase _getFinishedCropsDataUseCase;

  FinishedCropsViewModel({
    required this.growRoomId,
    //required GetFinishedCropsDataUseCase getFinishedCropsDataUseCase,
  }) /*: _getFinishedCropsDataUseCase = getFinishedCropsDataUseCase*/ {
    fetchAllData();
  }

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

    try {/*
      final data = await _getFinishedCropsDataUseCase(growRoomId);
      _allFinishedCrops = data.finishedCrops;
      _growRoomName = data.growRoomName;*/
    } catch (e) {
      _error = 'Ocurrió un error al cargar los datos: ${e.toString()}';
      _allFinishedCrops = [];
      _growRoomName = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
