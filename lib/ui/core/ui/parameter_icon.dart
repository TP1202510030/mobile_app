import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';

class ParameterIcon extends StatelessWidget {
  final Measurement measurement;
  final double size;

  const ParameterIcon({
    super.key,
    required this.measurement,
    this.size = AppSizes.iconSizeMedium,
  });

  static final _numberFormatter = NumberFormat('#,##0.##', 'es_ES');

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final textStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: onSurfaceColor);
    final formattedValue = _numberFormatter.format(measurement.value);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            measurement.parameter.iconPath,
            colorFilter: ColorFilter.mode(
              onSurfaceColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingExtraSmall),
        Text(
          '$formattedValue${measurement.unitOfMeasurement}',
          style: textStyle,
        ),
      ],
    );
  }
}
