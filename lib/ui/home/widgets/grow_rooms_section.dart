import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/utils/icon_utils.dart';
import '../../core/ui/search_bar.dart';
import '../ui/grow_room_card.dart';
import '../view_models/home_viewmodel.dart';
import '../../core/ui/parameter_icon.dart';
import '../../core/themes/icons.dart';
import 'package:go_router/go_router.dart';

class GrowRoomSection extends StatelessWidget {
  final HomeViewModel viewModel;
  const GrowRoomSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          hintText: "Buscar nave...",
          controller: viewModel.searchController,
          onChanged: (_) {},
          onClear: viewModel.searchController.clear,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (_, __) {
              final rooms = viewModel.growRooms;

              if (rooms.isEmpty) {
                return Column(
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

              return ListView.separated(
                itemCount: rooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final room = rooms[index];
                  final params = room.latestMeasurements.map((m) {
                    return ParameterIcon(
                      iconPath: IconUtils.getIconForParameter(m.parameter),
                      value: m.value,
                      unitOfMeasure: m.unitOfMeasurement,
                    );
                  }).toList();

                  return GrowRoomCard(
                    title: room.name,
                    imagePath: room.imageUrl,
                    parameters: params,
                    onTap: () => context.push('/crop/${room.id}'),
                    hasActiveCrop: room.hasActiveCrop,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
