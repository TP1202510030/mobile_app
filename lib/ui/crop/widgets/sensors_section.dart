import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/utils/icon_utils.dart';
import 'package:mobile_app/ui/crop/view_models/crop_viewmodel.dart';

class SensorsSection extends StatelessWidget {
  final CropViewModel viewModel;

  const SensorsSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        if (viewModel.isLoadingMeasurements) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.measurementError != null) {
          return Center(
            child: Text(
              'Error: ${viewModel.measurementError}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (viewModel.latestMeasurements.isEmpty) {
          return Center(
            child: Text(
              'No hay mediciones disponibles para esta fase.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 24.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.start,
              children: viewModel.latestMeasurements.map((measurement) {
                return ParameterIcon(
                  iconPath:
                      IconUtils.getIconForParameter(measurement.parameter),
                  value: measurement.value,
                  unitOfMeasure: measurement.unitOfMeasurement,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
