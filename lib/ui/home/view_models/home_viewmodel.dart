import 'package:flutter/material.dart';
import 'package:mobile_app/data/services/api/model/grow_room/grow_room_service.dart';
import 'package:mobile_app/domain/models/grow_room/grow_room.dart';

class HomeViewModel extends ChangeNotifier {
  final GrowRoomService _service;
  List<GrowRoom> _growRooms = [];
  int _selectedTabIndex = 0;
  bool _isLoading = false;

  HomeViewModel(this._service) {
    fetchGrowRooms(1);
    searchController.addListener(_onSearchChanged);
  }

  final TextEditingController searchController = TextEditingController();

  List<GrowRoom> get growRooms => _filteredGrowRooms;
  String get searchQuery => _searchQuery;
  bool get hasNotification => _hasNotification;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  bool _hasNotification = false;
  VoidCallback? onNotificationTap;

  set hasNotification(bool value) {
    if (_hasNotification != value) {
      _hasNotification = value;
      notifyListeners();
    }
  }

  List<GrowRoom> get _filteredGrowRooms {
    if (_searchQuery.isEmpty) return _growRooms;
    return _growRooms
        .where((room) =>
            room.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
      notifyListeners();
    }
  }

  void _onSearchChanged() {
    _searchQuery = searchController.text;
    notifyListeners();
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
