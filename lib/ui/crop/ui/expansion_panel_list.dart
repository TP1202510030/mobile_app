import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class PanelItem {
  final String id;
  final String iconPath;
  final String title;
  final Widget body;

  const PanelItem({
    required this.id,
    required this.iconPath,
    required this.title,
    required this.body,
  });
}

class CustomExpansionPanelList extends StatefulWidget {
  final List<PanelItem> items;
  final Duration animationDuration;

  const CustomExpansionPanelList({
    super.key,
    required this.items,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomExpansionPanelList> createState() =>
      _CustomExpansionPanelListState();
}

class _CustomExpansionPanelListState extends State<CustomExpansionPanelList> {
  final Set<String> _openPanelIds = {};

  void _togglePanel(String panelId) {
    setState(() {
      if (_openPanelIds.contains(panelId)) {
        _openPanelIds.remove(panelId);
      } else {
        _openPanelIds.add(panelId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        final isExpanded = _openPanelIds.contains(item.id);
        return _ExpansionPanel(
          item: item,
          isExpanded: isExpanded,
          onTap: () => _togglePanel(item.id),
          animationDuration: widget.animationDuration,
        );
      }).toList(),
    );
  }
}

class _ExpansionPanel extends StatelessWidget {
  final PanelItem item;
  final bool isExpanded;
  final VoidCallback onTap;
  final Duration animationDuration;

  const _ExpansionPanel({
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerTextColor = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingLarge,
                vertical: AppSizes.spacingMedium,
              ),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: animationDuration,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: headerTextColor,
                      size: AppSizes.iconSizeMedium,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  SvgPicture.asset(
                    item.iconPath,
                    width: AppSizes.iconSizeMedium,
                    height: AppSizes.iconSizeMedium,
                    colorFilter: ColorFilter.mode(
                      headerTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: Text(
                      item.title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: headerTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingLarge,
                vertical: AppSizes.spacingMedium,
              ),
              child: item.body,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: animationDuration,
          ),
        ],
      ),
    );
  }
}
