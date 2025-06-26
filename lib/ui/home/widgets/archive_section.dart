import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/home/ui/archive_grow_room_card.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

class ArchiveSection extends StatelessWidget {
  final HomeViewModel viewModel;

  static const int _gridCrossAxisCount = 3;
  static const double _cardAspectRatio = 1.0;
  static const double _gridSpacing = 16.0;

  const ArchiveSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.growRooms.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.home,
            width: 64.0,
            height: 64.0,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No existen naves para mostrar',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount,
        childAspectRatio: _cardAspectRatio,
        crossAxisSpacing: _gridSpacing,
        mainAxisSpacing: _gridSpacing,
      ),
      itemCount: viewModel.growRooms.length,
      itemBuilder: (context, index) {
        final room = viewModel.growRooms[index];
        return ArchiveGrowRoomCard(
          name: room.name,
          imageUrl: room.imageUrl,
          onTap: () {
            final path = Routes.finishedCrops.replaceAll(
              ':growRoomId',
              room.id.toString(),
            );
            context.push(path);
          },
        );
      },
    );
  }
}
