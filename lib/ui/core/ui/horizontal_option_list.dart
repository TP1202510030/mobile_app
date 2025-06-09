import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  void _onOptionTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.options[index].onTap?.call();
    widget.onItemSelected?.call(index);
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
          final option = widget.options[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => _onOptionTap(index),
            child: Container(
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    option.iconPath,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    option.title,
                    style: isSelected
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
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
