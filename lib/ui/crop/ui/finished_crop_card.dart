import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/crop/crop.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';

class FinishedCropCard extends StatelessWidget {
  final Crop crop;

  const FinishedCropCard({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'es_ES');
    final startDate = dateFormat.format(crop.startDate.toLocal());
    final endDate = crop.endDate != null
        ? dateFormat.format(crop.endDate!.toLocal())
        : 'N/A';
    final totalProduction = crop.totalProduction?.toStringAsFixed(2) ?? 'N/A';

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          final path = AppRoutes.finishedCropDetail(
            growRoomId: crop.growRoomId.toString(),
            cropId: crop.id.toString(),
          );
          context.push(path, extra: {'totalProduction': totalProduction});
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cultivo #${crop.id}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              _CardInfoRow(
                iconPath: AppIcons.calendar,
                text: '$startDate - $endDate',
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              _CardInfoRow(
                iconPath: AppIcons.mushroom,
                text: 'Producción total: $totalProduction Tn',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardInfoRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const _CardInfoRow({
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: AppSizes.iconSizeSmall,
          height: AppSizes.iconSizeSmall,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppSizes.spacingMedium),
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
