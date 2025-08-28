/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomExpansionPanelList extends StatefulWidget {
  final List<PanelItem> items;
  final Duration animationDuration;

  const CustomExpansionPanelList({
    super.key,
    required this.items,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<CustomExpansionPanelList> createState() =>
      _CustomExpansionPanelListState();
}

class _CustomExpansionPanelListState extends State<CustomExpansionPanelList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        return _buildPanel(item);
      }).toList(),
    );
  }

  Widget _buildPanel(PanelItem item) {
    final headerTextColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.blockSizeVertical * 1),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              item.tooltipBehavior.hide();

              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) {
                  setState(() {
                    item.isExpanded = !item.isExpanded;
                  });
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.blockSizeHorizontal * 4,
                vertical: AppSizes.blockSizeVertical * 2,
              ),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: item.isExpanded ? 0.5 : 0.0,
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: headerTextColor,
                      size: AppSizes.blockSizeHorizontal * 6,
                    ),
                  ),
                  SizedBox(width: AppSizes.blockSizeHorizontal * 2),
                  SvgPicture.asset(
                    item.iconPath,
                    width: AppSizes.blockSizeHorizontal * 6,
                    height: AppSizes.blockSizeHorizontal * 6,
                    colorFilter: ColorFilter.mode(
                      headerTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: AppSizes.blockSizeHorizontal * 4),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: headerTextColor),
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

class PanelItem {
  final String iconPath;
  final String title;
  final Widget body;
  final TooltipBehavior tooltipBehavior;
  bool isExpanded;

  PanelItem({
    required this.iconPath,
    required this.title,
    required this.body,
    required this.tooltipBehavior,
    this.isExpanded = false,
  });
}
*/