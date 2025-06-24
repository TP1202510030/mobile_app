import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ParameterIcon extends StatelessWidget {
  final String iconPath;
  final double value;
  final String? unitOfMeasure;

  const ParameterIcon({
    super.key,
    required this.iconPath,
    required this.value,
    this.unitOfMeasure,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = NumberFormat('#,##0.##', 'es_ES').format(value);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: SvgPicture.asset(
            iconPath,
            width: 32.0,
            height: 32.0,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          '$formattedValue${unitOfMeasure != null ? ' $unitOfMeasure' : ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
