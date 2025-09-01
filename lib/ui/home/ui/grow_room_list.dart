import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/home/ui/grow_room_card.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

class GrowRoomList extends StatefulWidget {
  final List<GrowRoom> growRooms;
  final bool hasMore;
  final HomeViewModel viewModel;

  const GrowRoomList({
    super.key,
    required this.growRooms,
    required this.hasMore,
    required this.viewModel,
  });

  @override
  State<GrowRoomList> createState() => _GrowRoomListState();
}

class _GrowRoomListState extends State<GrowRoomList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.viewModel.fetchMoreGrowRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.viewModel.fetchInitialGrowRooms,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: widget.hasMore
            ? widget.growRooms.length + 1
            : widget.growRooms.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.spacingMedium),
        itemBuilder: (context, index) {
          if (index >= widget.growRooms.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final growRoom = widget.growRooms[index];
          return GrowRoomCard(
            growRoom: growRoom,
            onTap: () {
              // To-do
            },
            onStartCrop: () {
              context.push(AppRoutes.startCreateCrop(
                  growRoomId: growRoom.id.toString()));
            },
          );
        },
      ),
    );
  }
}
