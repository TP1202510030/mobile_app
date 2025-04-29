import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.unselectedItemColor = AppColors.grey,
    this.selectedItemColor = AppColors.white,
    this.currentIndex = 0,
  });

  final List<NavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final Color unselectedItemColor;
  final Color selectedItemColor;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.blockSizeHorizontal * 5,
        0,
        AppSizes.blockSizeHorizontal * 5,
        32,
      ),
      child: Container(
        width: AppSizes.screenWidth,
        height: AppSizes.blockSizeHorizontal * 17,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return InkWell(
              onTap: () => onTap?.call(index),
              child: Stack(
                alignment: const Alignment(1, .5),
                children: [
                  SvgPicture.asset(
                    item.icon,
                    width: 36.0,
                    height: 36.0,
                    colorFilter: ColorFilter.mode(
                      index == currentIndex
                          ? selectedItemColor
                          : unselectedItemColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (item.hasNotification)
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: RedDot(),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavigationBarItem {
  const NavigationBarItem({
    required this.icon,
    required this.hasNotification,
    this.selectedIconData,
  });

  final String icon;
  final bool hasNotification;
  final IconData? selectedIconData;
}

class RedDot extends StatelessWidget {
  const RedDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: AppColors.red,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
