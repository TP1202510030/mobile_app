import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/actuator_icon.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/home/ui/grow_room_card.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

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
          onChanged: viewModel.setSearchQuery,
          onClear: () => viewModel.setSearchQuery(''),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (_, __) {
              final rooms = viewModel.growRooms;

              if (rooms.isEmpty && viewModel.searchQuery.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No se encontró la nave "${viewModel.searchQuery}"',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              if (rooms.isEmpty) {
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

              return RefreshIndicator(
                onRefresh: viewModel.fetchGrowRooms,
                child: ListView.separated(
                  itemCount: rooms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final room = rooms[index];

                    final params = room.latestMeasurements.map((m) {
                      final parameterEnum = ParameterData.fromKey(m.parameter);
                      return ParameterIcon(
                        iconPath: parameterEnum.iconPath,
                        value: m.value,
                        unitOfMeasure: m.unitOfMeasurement,
                      );
                    }).toList();

                    final actuators = room.actuatorStates.entries.map((entry) {
                      final actuatorEnum = ActuatorData.fromKey(entry.key);
                      return ActuatorIcon(
                        iconPath: actuatorEnum.iconPath,
                        isActive: entry.value == 'ACTIVATED',
                      );
                    }).toList();

                    return GrowRoomCard(
                      title: room.name,
                      imagePath: room.imageUrl,
                      parameters: params,
                      actuators: actuators,
                      onTap: room.hasActiveCrop
                          ? () => context.push(
                                Routes.crop.replaceAll(
                                    ':cropId', room.activeCropId.toString()),
                                extra: room.name,
                              )
                          : null,
                      hasActiveCrop: room.hasActiveCrop,
                      onStartCrop: () => context.push(Routes.createCrop
                          .replaceAll(':growRoomId', room.id.toString())),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
