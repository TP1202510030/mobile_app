import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

import '../themes/icons.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.onTap,
    this.color,
  });

  final GestureTapCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.iconSizeLarge,
      width: AppSizes.iconSizeLarge,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            if (context.canPop()) {
              context.pop();
            }
          }
        },
        child: Center(
          child: SvgPicture.asset(
            AppIcons.arrowLeft,
            width: 32.0,
            height: 32.0,
            colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
