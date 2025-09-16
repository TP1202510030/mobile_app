import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/home/ui/grow_room_list.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

/// A widget that displays a list of grow room cards.
///
/// Its responsibility is to react to the [HomeViewModel] state to
/// display a list of grow rooms and handles the empty state.
class GrowRoomsSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const GrowRoomsSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final filteredRooms = viewModel.growRooms;
        final isLoading = viewModel.isLoading;
        final error = viewModel.error;

        if (isLoading && filteredRooms.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && filteredRooms.isEmpty) {
          return Center(
            child: Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        if (filteredRooms.isEmpty) {
          return _buildEmptyState(context, viewModel.searchController.text);
        }

        return GrowRoomList(
          growRooms: filteredRooms,
          hasMore: viewModel.hasMoreGrowRooms,
          viewModel: viewModel,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final isFiltering = searchQuery.isNotEmpty;

    final message = isFiltering
        ? "No se encontró la nave con nombre '$searchQuery'"
        : "No existen naves para mostrar";

    return EmptyState(message: message, iconAsset: AppIcons.home);
  }
}
