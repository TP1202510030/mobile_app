import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        BlendMode.srcIn,
      ),
    );
  }
}
