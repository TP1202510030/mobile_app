import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

class PanelItem {
  final String iconPath;
  final String title;
  final Widget body;
  bool isExpanded;

  PanelItem({
    required this.iconPath,
    required this.title,
    required this.body,
    this.isExpanded = false,
  });
}

class CustomExpansionPanelList extends StatefulWidget {
  final List<PanelItem> items;
  final Duration animationDuration;
  final Color headerBackground;
  final Color headerTextColor;

  const CustomExpansionPanelList({
    super.key,
    required this.items,
    this.animationDuration = const Duration(milliseconds: 200),
    this.headerBackground = AppColors.white,
    this.headerTextColor = AppColors.black,
  });

  @override
  _CustomExpansionPanelListState createState() =>
      _CustomExpansionPanelListState();
}

class _CustomExpansionPanelListState extends State<CustomExpansionPanelList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        return _buildPanel(item);
      }).toList(),
    );
  }

  Widget _buildPanel(PanelItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.blockSizeVertical * 1),
      decoration: BoxDecoration(
        color: widget.headerBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                item.isExpanded = !item.isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.blockSizeHorizontal * 4,
                vertical: AppSizes.blockSizeVertical * 2,
              ),
              child: Row(
                children: [
                  // Icono SVG
                  SvgPicture.asset(
                    item.iconPath,
                    width: AppSizes.blockSizeHorizontal * 6,
                    height: AppSizes.blockSizeHorizontal * 6,
                  ),
                  SizedBox(width: AppSizes.blockSizeHorizontal * 4),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: widget.headerTextColor),
                    ),
                  ),
                  AnimatedRotation(
                    turns: item.isExpanded ? 0.5 : 0.0,
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.headerTextColor,
                      size: AppSizes.blockSizeHorizontal * 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.blockSizeHorizontal * 4,
                vertical: AppSizes.blockSizeVertical * 2,
              ),
              child: item.body,
            ),
            crossFadeState: item.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: widget.animationDuration,
          ),
        ],
      ),
    );
  }
}
