import 'package:flutter/material.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/ui/crop/ui/parameter_threshold_input';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class ThresholdCard extends StatelessWidget {
  final String phaseName;
  final Map<Parameter, ThresholdControllers> thresholdControllers;

  const ThresholdCard({
    super.key,
    required this.phaseName,
    required this.thresholdControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phaseName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...Parameter.values.map((param) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ParameterThresholdInput(
                  label: param.label,
                  minController: thresholdControllers[param]!.minController,
                  maxController: thresholdControllers[param]!.maxController,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
