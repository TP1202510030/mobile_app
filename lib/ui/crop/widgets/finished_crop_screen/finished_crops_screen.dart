import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../core/locator.dart';

class FinishedCropsScreen extends StatelessWidget {
  final int growRoomId;

  const FinishedCropsScreen({super.key, required this.growRoomId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<FinishedCropsViewModel>(param1: growRoomId),
      child: Consumer<FinishedCropsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          final crops = viewModel.finishedCrops;

          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.growRoomName,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  CustomSearchBar(
                    controller: viewModel.searchController,
                    hintText: 'Buscar por ID de cultivo...',
                    onChanged: viewModel.setSearchQuery,
                    onClear: () => viewModel.setSearchQuery(''),
                  ),
                  const SizedBox(height: 24),
                  if (crops.isEmpty && viewModel.searchQuery.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                            'No se encontró el cultivo "${viewModel.searchQuery}"'),
                      ),
                    )
                  else if (crops.isEmpty)
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
                          Text('No hay cultivos finalizados',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: crops.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) =>
                            _FinishedCropCard(crop: crops[index]),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FinishedCropCard extends StatelessWidget {
  final Crop crop;
  const _FinishedCropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'es_ES');
    final startDate = dateFormat.format(crop.startDate.toLocal());
    final endDate = crop.endDate != null
        ? dateFormat.format(crop.endDate!.toLocal())
        : 'N/A';
    final totalProduction = crop.totalProduction?.toStringAsFixed(2) ?? 'N/A';

    return InkWell(
      onTap: () {
        final path = AppRoutes.finishedCropDetail(
          growRoomId: crop.growRoomId.toString(),
          cropId: crop.id.toString(),
        );
        context.push(path, extra: {'totalProduction': totalProduction});
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cultivo #${crop.id}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            _CardInfoRow(
                iconPath: AppIcons.calendar, text: '$startDate - $endDate'),
            const SizedBox(height: 8),
            _CardInfoRow(
                iconPath: AppIcons.mushroom,
                text: 'Producción total: $totalProduction Tn'),
          ],
        ),
      ),
    );
  }
}

class _CardInfoRow extends StatelessWidget {
  final String iconPath;
  final String text;
  const _CardInfoRow({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 24, height: 24),
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
