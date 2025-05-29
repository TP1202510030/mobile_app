import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActuatorIcon extends StatelessWidget {
  final String iconPath;
  const ActuatorIcon({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: 32.0,
      height: 32.0,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.secondary,
        BlendMode.srcIn,
      ),
    );
  }
}
