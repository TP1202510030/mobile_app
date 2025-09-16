import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/grow_room/grow_room.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class ArchiveGrowRoomCard extends StatelessWidget {
  final GrowRoom growRoom;
  final VoidCallback onTap;

  const ArchiveGrowRoomCard({
    super.key,
    required this.growRoom,
    required this.onTap,
  });

  static const double _cardPadding = 8.0;
  static const int _maxTitleLines = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: growRoom.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.image_not_supported_outlined,
                size: AppSizes.iconSizeLarge,
                color: colorScheme.outline,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.shadow.withOpacity(0.9),
                    Colors.transparent
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: _cardPadding,
              left: _cardPadding,
              right: _cardPadding,
              child: Text(
                growRoom.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: _maxTitleLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
