import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/control_action/control_action_type.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/ui/actuator_icon.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';

class GrowRoomCard extends StatelessWidget {
  final GrowRoom growRoom;
  final VoidCallback onTap;
  final VoidCallback onStartCrop;

  const GrowRoomCard({
    super.key,
    required this.growRoom,
    required this.onTap,
    required this.onStartCrop,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.all(Radius.circular(AppSizes.borderRadiusLarge)),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: AppSizes.cardBorderSize,
        ),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMedium),
        child: Row(
          children: [
            _buildGrowRoomImage(),
            const SizedBox(width: AppSizes.spacingLarge),
            Expanded(
              child: growRoom.hasActiveCrop
                  ? _buildActiveContent(context)
                  : _buildInactiveContent(context),
            ),
          ],
        ),
      ),
    );

    return growRoom.hasActiveCrop
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            child: cardContent,
          )
        : cardContent;
  }

  Widget _buildGrowRoomImage() {
    return SizedBox(
      width: AppSizes.cardImageSize,
      height: AppSizes.cardImageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        child: CachedNetworkImage(
          imageUrl: growRoom.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(
            Icons.image_not_supported_outlined,
            size: AppSizes.iconSizeLarge,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                growRoom.name,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildActuatorIcons(),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        _buildParameterIcons(context),
      ],
    );
  }

  Widget _buildInactiveContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          growRoom.name,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        CustomButton(
          onTap: onStartCrop,
          isFullWidth: true,
          variant: ButtonVariant.primary,
          child: Text(
            'Iniciar cultivo',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActuatorIcons() {
    if (growRoom.actuatorStates.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: growRoom.actuatorStates.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(left: AppSizes.spacingSmall),
          child: ActuatorIcon(
            actuator: entry.key,
            isActive: entry.value == ControlActionType.activated.key,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParameterIcons(BuildContext context) {
    if (growRoom.latestMeasurements.isEmpty) {
      return Text(
        'Aún no hay mediciones disponibles.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: growRoom.latestMeasurements.map((measurement) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacingLarge),
            child: ParameterIcon(measurement: measurement),
          );
        }).toList(),
      ),
    );
  }
}
