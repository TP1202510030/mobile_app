import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

class ActuatorIcon extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  const ActuatorIcon({
    super.key,
    required this.iconPath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: 32.0,
      height: 32.0,
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.accent : Theme.of(context).colorScheme.outline,
        BlendMode.srcIn,
      ),
    );
  }
}
