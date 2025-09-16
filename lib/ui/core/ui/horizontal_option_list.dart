import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class HorizontalOptionList extends StatefulWidget {
  final List<OptionItemData> options;
  final ValueChanged<int>? onItemSelected;
  final int initialIndex;

  const HorizontalOptionList({
    super.key,
    required this.options,
    this.onItemSelected,
    this.initialIndex = 0,
  });

  @override
  State<HorizontalOptionList> createState() => _HorizontalOptionListState();
}

class _HorizontalOptionListState extends State<HorizontalOptionList> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant HorizontalOptionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        selectedIndex = widget.initialIndex;
      });
    }
  }

  void _onOptionTap(int index) {
    widget.options[index].onTap?.call();
    widget.onItemSelected?.call(index);

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        itemCount: widget.options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 32),
        itemBuilder: (context, index) {
          return _OptionItem(
            data: widget.options[index],
            isSelected: index == selectedIndex,
            onTap: () => _onOptionTap(index),
          );
        },
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final OptionItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    final TextStyle? textStyle = isSelected
        ? Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              data.iconPath,
              width: AppSizes.iconSizeMedium,
              height: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                contentColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              data.title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItemData {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  OptionItemData({
    required this.title,
    required this.iconPath,
    this.onTap,
  });
}
