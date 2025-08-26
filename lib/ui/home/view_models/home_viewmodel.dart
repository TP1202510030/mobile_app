import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_rooms_by_company_id_use_case.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_out_use_case.dart';

class HomeViewModel extends ChangeNotifier {
  final GetGrowRoomsByCompanyIdUseCase _getHomeDataUseCase;
  final AuthRepository _authRepository;
  final SignOutUseCase _signOutUseCase;

  HomeViewModel({
    required GetGrowRoomsByCompanyIdUseCase getHomeDataUseCase,
    required AuthRepository authRepository,
    required SignOutUseCase signOutUseCase,
  })  : _getHomeDataUseCase = getHomeDataUseCase,
        _authRepository = authRepository,
        _signOutUseCase = signOutUseCase {
    fetchGrowRooms();
  }

  // --- Estado Interno ---
  List<GrowRoom> _growRooms = [];
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  // --- Getters Públicos ---
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  List<GrowRoom> get growRooms => _filteredGrowRooms;

  bool hasNotification = false;
  VoidCallback? onNotificationTap;

  List<GrowRoom> get _filteredGrowRooms {
    if (_searchQuery.isEmpty) return _growRooms;
    return _growRooms
        .where((room) =>
            room.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  Future<void> fetchGrowRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final companyId = _authRepository.companyId;
      if (companyId == null) {
        throw Exception(
            'ID de compañía no encontrado. Por favor, inicie sesión de nuevo.');
      }

      _growRooms = await _getHomeDataUseCase(
          GetGrowRoomsByCompanyIdParams(companyId: companyId));
    } catch (e) {
      _error = 'Error al cargar las naves: ${e.toString()}';
      developer.log(_error ?? 'Error desconocido al cargar las naves');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshGrowRooms() async {
    await fetchGrowRooms();
  }

  void selectTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      searchController.clear();
      setSearchQuery('');
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase(null);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void handleNotificationTap() {
    onNotificationTap?.call();
  }
}
