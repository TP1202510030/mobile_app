import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';

class SummaryItem {
  final String label;
  final String value;
  final String? iconPath;

  const SummaryItem({
    required this.label,
    required this.value,
    this.iconPath,
  });
}

class ConfirmationSummaryData {
  final String title;
  final String subtitle;
  final List<SummaryItem> items;

  const ConfirmationSummaryData({
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

class ConfirmationSummaryCard extends StatelessWidget {
  final ConfirmationSummaryData data;

  const ConfirmationSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.only(bottom: AppSizes.spacingLarge),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(title: data.title, subtitle: data.subtitle),
            const SizedBox(height: AppSizes.spacingLarge),
            ...data.items.map((item) => _SummaryRow(item: item)),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.item});

  final SummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (item.iconPath != null) ...[
            SvgPicture.asset(
              item.iconPath!,
              width: AppSizes.iconSizeSmall,
              height: AppSizes.iconSizeSmall,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSizes.spacingMedium),
          ],
          Expanded(
            flex: 3,
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.value,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
