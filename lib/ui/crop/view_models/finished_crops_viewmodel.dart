import 'package:flutter/material.dart';
import 'package:mobile_app/data/services/api/model/grow_room/crop_service.dart';
import 'package:mobile_app/data/services/api/model/grow_room/grow_room_service.dart';
import 'package:mobile_app/domain/models/grow_room/crop.dart';
import 'package:mobile_app/domain/models/grow_room/grow_room.dart';

class FinishedCropsViewModel extends ChangeNotifier {
  final int growRoomId;
  final CropService _cropService;
  final GrowRoomService _growRoomService;

  // STATE
  List<Crop> _finishedCrops = [];
  bool _isLoading = true;
  String? _error;
  String _growRoomName = '';
  String _searchQuery = '';

  final TextEditingController searchController = TextEditingController();

  // GETTERS
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get growRoomName => _growRoomName;

  List<Crop> get finishedCrops {
    if (_searchQuery.isEmpty) {
      return _finishedCrops;
    }
    // Filtra los cultivos por su ID
    return _finishedCrops
        .where(
            (crop) => crop.id.toString().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // CONSTRUCTOR
  FinishedCropsViewModel({
    required this.growRoomId,
    required CropService cropService,
    required GrowRoomService growRoomService,
  })  : _cropService = cropService,
        _growRoomService = growRoomService {
    searchController.addListener(_onSearchChanged);
    fetchAllData();
  }

  // LIFECYCLE
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  // METHODS
  void _onSearchChanged() {
    if (_searchQuery != searchController.text) {
      _searchQuery = searchController.text;
      notifyListeners();
    }
  }

  Future<void> fetchAllData() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final results = await Future.wait([
        _cropService.getCropsByGrowRoomId(growRoomId),
        _growRoomService.getGrowRoomsByCompanyId(1),
      ]);

      final allCrops = results[0] as List<Crop>;
      final allGrowRooms = results[1] as List<GrowRoom>;

      _finishedCrops = allCrops.where((crop) => crop.endDate != null).toList();

      try {
        final growRoom =
            allGrowRooms.firstWhere((room) => room.id == growRoomId);
        _growRoomName = growRoom.name;
      } catch (e) {
        _growRoomName = 'Nave Desconocida';
        debugPrint('Error: No se encontró la nave con id $growRoomId. $e');
      }
    } catch (e) {
      debugPrint('Error fetching finished crops data: $e');
      _error = 'Ocurrió un error al cargar los datos.';
      _finishedCrops = [];
      _growRoomName = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
