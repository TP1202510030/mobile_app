import 'package:flutter/material.dart';
import 'package:mobile_app/data/services/api/model/grow_room/grow_room_service.dart';
import 'package:mobile_app/domain/models/grow_room/grow_room.dart';

class HomeViewModel extends ChangeNotifier {
  final GrowRoomService _service;
  List<GrowRoom> _growRooms = [];
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String _searchQuery = '';

  HomeViewModel(this._service) {
    fetchGrowRooms(1);
  }

  final TextEditingController searchController = TextEditingController();

  List<GrowRoom> get growRooms => _filteredGrowRooms;
  String get searchQuery => _searchQuery;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;

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

  Future<void> fetchGrowRooms(int companyId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _growRooms = await _service.getGrowRoomsByCompanyId(companyId);
      debugPrint(
          'Fetched grow rooms: ${_growRooms.map((room) => room.name).join(', ')}');
    } catch (e) {
      debugPrint('Error fetching grow rooms: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      searchController.clear();
      setSearchQuery('');
      notifyListeners();
    }
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
