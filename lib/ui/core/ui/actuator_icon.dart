import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/ui/core/themes/app_accent_colors.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/utils/actuator_extensions.dart';

class ActuatorIcon extends StatelessWidget {
  final Actuator actuator;
  final bool isActive;
  final double size;

  const ActuatorIcon({
    super.key,
    required this.actuator,
    required this.isActive,
    this.size = AppSizes.iconSizeMedium,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).extension<AppAccentColors>()!.accent;
    final inactiveColor = Theme.of(context).colorScheme.outline;

    return SvgPicture.asset(
      actuator.iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        isActive ? accentColor! : inactiveColor,
        BlendMode.srcIn,
      ),
    );
  }
}
