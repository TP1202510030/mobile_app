import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_rooms_by_company_id_use_case.dart';
import 'package:mobile_app/utils/result.dart';

enum HomeTab { growRooms, archive }

class HomeViewModel extends ChangeNotifier {
  final GetGrowRoomsByCompanyIdUseCase _getGrowRoomsUseCase;
  final AuthRepository _authRepository;

  HomeViewModel(this._getGrowRoomsUseCase)
      : _authRepository = locator<AuthRepository>() {
    searchController.addListener(_onSearchChanged);
  }

  bool _isLoading = false;
  String? _error;
  List<GrowRoom> _growRooms = [];
  int _currentPage = ApiConstants.defaultPage;
  bool _hasMoreGrowRooms = true;
  bool _isFetchingMore = false;
  HomeTab _selectedTab = HomeTab.growRooms;
  String _searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  static const Duration debounceDuration = Duration(milliseconds: 200);
  Timer? _debounce;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreGrowRooms => _hasMoreGrowRooms;
  HomeTab get selectedTab => _selectedTab;

  List<GrowRoom> get growRooms {
    if (_searchQuery.isEmpty) return _growRooms;
    final query = _searchQuery.toLowerCase();
    return _growRooms
        .where((request) => request.name.toLowerCase().contains(query))
        .toList();
  }

  Future<void> fetchInitialGrowRooms() async {
    _currentPage = ApiConstants.defaultPage;
    _hasMoreGrowRooms = true;
    _error = null;
    _setLoading(true);
    await _loadPage(reset: true);
    _setLoading(false);
  }

  Future<void> refreshGrowRooms() async {
    await fetchInitialGrowRooms();
  }

  Future<void> fetchMoreGrowRooms() async {
    if (_isFetchingMore || !_hasMoreGrowRooms) return;
    _isFetchingMore = true;
    _currentPage += 1;
    await _loadPage(reset: false);
    _isFetchingMore = false;
  }

  void selectTab(int index) {
    final newTab = HomeTab.values[index];
    if (_selectedTab != newTab) {
      _selectedTab = newTab;
      searchController.clear();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () {
      _searchQuery = searchController.text.trim();
      notifyListeners();
    });
  }

  Future<void> _loadPage({required bool reset}) async {
    final companyId = _authRepository.companyId;
    if (companyId == null) {
      _error = 'No se pudo determinar la compañía del usuario.';
      notifyListeners();
      return;
    }

    final params = GetGrowRoomsByCompanyIdParams(
      companyId: companyId,
      page: _currentPage,
      size: ApiConstants.defaultPageSize,
    );

    final result = await _getGrowRoomsUseCase(params);
    switch (result) {
      case Success(value: final paged):
        if (reset) {
          _growRooms = paged.content;
        } else {
          _growRooms.addAll(paged.content);
        }
        _hasMoreGrowRooms = !paged.isLast;
        _error = null;
        notifyListeners();
        break;
      case Error(error: final e):
        _error = 'Error al cargar naves: ${e.toString()}';
        notifyListeners();
        break;
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
