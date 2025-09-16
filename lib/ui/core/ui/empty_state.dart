import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String iconAsset;
  final double iconSize;
  const EmptyState({
    super.key,
    required this.message,
    required this.iconAsset,
    this.iconSize = AppSizes.iconSizeLarge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Text(message,
              style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
