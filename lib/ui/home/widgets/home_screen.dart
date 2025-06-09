import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/home/widgets/grow_rooms_section.dart';
import '../view_models/home_viewmodel.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  List<OptionItemData> get _horizontalOptions => [
        OptionItemData(
          title: "Naves de cultivo",
          onTap: () {},
          iconPath: AppIcons.home,
        ),
        OptionItemData(
          title: "Cultivos terminados",
          onTap: () {},
          iconPath: AppIcons.cropsArchive,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "31 de mayo del 2025",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 32),
          HorizontalOptionList(options: _horizontalOptions),
          const SizedBox(height: 32),
          Expanded(
            child: GrowRoomSection(viewModel: viewModel),
          ),
        ],
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    required this.icon,
    required this.hasNotification,
  });

  final String icon;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.0,
      height: 32.0,
      child: Stack(
        children: [
          SvgPicture.asset(
            icon,
            width: 32.0,
            height: 32.0,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
          if (hasNotification)
            const Positioned(
              top: 0,
              right: 0,
              child: RedDot(),
            ),
        ],
      ),
    );
  }
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
            color: AppColors.alert,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
