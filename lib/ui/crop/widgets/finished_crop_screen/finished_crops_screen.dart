import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/models/grow_room/crop.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:go_router/go_router.dart';

class FinishedCropsScreen extends StatelessWidget {
  final FinishedCropsViewModel viewModel;

  const FinishedCropsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text(viewModel.error!));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                viewModel.growRoomName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              _SearchBarSection(viewModel: viewModel),
              const SizedBox(height: 24),
              if (viewModel.finishedCrops.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.mushroom,
                        width: 64.0,
                        height: 64.0,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No hay cultivos finalizados para mostrar',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: viewModel.finishedCrops.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final crop = viewModel.finishedCrops[index];
                      return _FinishedCropCard(crop: crop);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchBarSection extends StatelessWidget {
  final FinishedCropsViewModel viewModel;

  const _SearchBarSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchBar(
            controller: viewModel.searchController,
            hintText: 'Buscar cultivo...',
            onChanged: viewModel.setSearchQuery,
            onClear: () => viewModel.setSearchQuery(''),
          ),
        ),
      ],
    );
  }
}

class _FinishedCropCard extends StatelessWidget {
  final Crop crop;

  const _FinishedCropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = dateFormat.format(crop.startDate);
    final endDate =
        crop.endDate != null ? dateFormat.format(crop.endDate!) : 'N/A';

    final totalProduction = crop.totalProduction != null
        ? '${crop.totalProduction!.toStringAsFixed(2)} T'
        : 'N/A';

    return InkWell(
      onTap: () {
        final path = Routes.finishedCropDetail
            .replaceAll(':growRoomId', crop.growRoomId.toString())
            .replaceAll(
              ':cropId',
              crop.id.toString(),
            );
        context.push(path, extra: totalProduction);
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cultivo #${crop.id}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _CardInfoRow(
              svgIconPath: AppIcons.calendar,
              text: '$startDate - $endDate',
            ),
            const SizedBox(height: 8),
            _CardInfoRow(
              svgIconPath: AppIcons.mushroom,
              text: 'Producción total: $totalProduction',
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInfoRow extends StatelessWidget {
  final String? svgIconPath;
  final String text;

  const _CardInfoRow({
    this.svgIconPath,
    required this.text,
  }) : assert(svgIconPath != null, 'Se debe proveer un svgIconPath.');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          svgIconPath!,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
