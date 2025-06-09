import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../themes/icons.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onTap});

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.0,
      width: 32.0,
      child: Stack(
        children: [
          SizedBox(
            child: InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                } else {
                  context.pop();
                }
              },
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.arrowLeft,
                  width: 32.0,
                  height: 32.0,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
