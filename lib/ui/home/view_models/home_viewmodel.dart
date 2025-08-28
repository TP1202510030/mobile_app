import 'package:flutter/material.dart';
import 'package:mobile_app/config/api_constants.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/domain/use_cases/grow_room/get_grow_rooms_by_company_id_use_case.dart';
import 'package:mobile_app/utils/result.dart';

enum HomeTab { growRooms, archive }

class HomeViewModel extends ChangeNotifier {
  final GetGrowRoomsByCompanyIdUseCase _getGrowRoomsUseCase;
  final AuthRepository _authRepository;

  HomeViewModel(this._getGrowRoomsUseCase, this._authRepository) {
    searchController.addListener(_onSearchChanged);
  }

  bool _isLoading = false;
  String? _error;
  List<GrowRoom> _growRooms = [];
  int _currentPage = 0;
  bool _hasMoreGrowRooms = true;
  bool _isFetchingMore = false;
  HomeTab _selectedTab = HomeTab.growRooms;
  String _searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreGrowRooms => _hasMoreGrowRooms;
  HomeTab get selectedTab => _selectedTab;

  List<GrowRoom> get growRooms {
    if (_searchQuery.isEmpty) {
      return _growRooms;
    }
    final query = _searchQuery.toLowerCase();
    return _growRooms
        .where((room) => room.name.toLowerCase().contains(query))
        .toList();
  }

  void selectTab(int index) {
    final newTab = HomeTab.values[index];
    if (_selectedTab != newTab) {
      _selectedTab = newTab;
      searchController.clear();
      notifyListeners();
    }
  }

  Future<void> fetchInitialGrowRooms() async {
    _isLoading = true;
    _error = null;
    _currentPage = 0;
    _hasMoreGrowRooms = true;
    notifyListeners();

    await _fetchGrowRooms();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreGrowRooms() async {
    if (_isFetchingMore || !_hasMoreGrowRooms) return;

    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    await _fetchGrowRooms();

    _isFetchingMore = false;
    notifyListeners();
  }

  void _onSearchChanged() {
    if (_searchQuery != searchController.text) {
      _searchQuery = searchController.text;
      notifyListeners();
    }
  }

  Future<void> _fetchGrowRooms() async {
    final companyId = _authRepository.companyId;
    if (companyId == null) {
      _error = "Could not get company ID.";
      return;
    }

    final params = GetGrowRoomsByCompanyIdParams(
      companyId: companyId,
      page: _currentPage,
      size: ApiConstants.defaultPageSize,
    );
    final result = await _getGrowRoomsUseCase(params);

    if (result is Success) {
      final pagedResult = (result as Success).value;
      if (_currentPage == 0) {
        _growRooms = pagedResult.content;
      } else {
        _growRooms.addAll(pagedResult.content);
      }
      _hasMoreGrowRooms = !pagedResult.isLast;
    } else if (result is Error) {
      _error =
          "Error loading grow rooms: ${(result as Error).error.toString()}";
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
