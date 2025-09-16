import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/home/ui/archive_grow_room_card.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

class ArchivedCropsSection extends StatelessWidget {
  static const int _gridCrossAxisCount = 3;
  static const double _cardAspectRatio = 1.0;
  static const double _gridSpacing = 16.0;

  final HomeViewModel viewModel;

  const ArchivedCropsSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final filteredRooms = viewModel.growRooms;
        final searchQuery = viewModel.searchController.text;

        if (filteredRooms.isEmpty) {
          return _buildEmptyState(context, searchQuery);
        }

        return RefreshIndicator(
          onRefresh: viewModel.fetchInitialGrowRooms,
          child: _buildGridView(context, filteredRooms),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<dynamic> rooms) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount,
        childAspectRatio: _cardAspectRatio,
        crossAxisSpacing: _gridSpacing,
        mainAxisSpacing: _gridSpacing,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ArchiveGrowRoomCard(
          growRoom: room,
          onTap: () {
            final path =
                AppRoutes.finishedCropList(growRoomId: room.id.toString());
            context.push(path);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final bool isFiltering = searchQuery.isNotEmpty;

    final String message = isFiltering
        ? "No se encontró la nave con nombre '$searchQuery'"
        : "No existen naves para mostrar";

    return EmptyState(message: message, iconAsset: AppIcons.home);
  }
}
