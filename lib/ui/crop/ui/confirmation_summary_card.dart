import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class ConfirmationSummaryCard extends StatelessWidget {
  final String phaseName;
  final String duration;
  final Map<Parameter, ThresholdControllers> thresholdControllers;

  const ConfirmationSummaryCard({
    super.key,
    required this.phaseName,
    required this.duration,
    required this.thresholdControllers,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  phaseName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  duration.isNotEmpty
                      ? '$duration días'
                      : 'Duración no definida',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...Parameter.values.map((param) {
              final min = thresholdControllers[param]!.minController.text;
              final max = thresholdControllers[param]!.maxController.text;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(param.label,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis)),
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Min: ${min.isNotEmpty ? min : 'N/A'} / Max: ${max.isNotEmpty ? max : 'N/A'}',
                          style: textTheme.bodySmall,
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
