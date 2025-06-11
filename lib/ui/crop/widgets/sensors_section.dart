import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/crop/ui/expansion_panel_list.dart';
import 'package:mobile_app/ui/crop/ui/line_chart.dart';
import 'package:mobile_app/utils/icon_utils.dart';
import 'package:mobile_app/ui/crop/view_models/crop_viewmodel.dart';

class SensorsSection extends StatelessWidget {
  final CropViewModel viewModel;

  const SensorsSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
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

        if (viewModel.measurementsByParameter.isEmpty) {
          return Center(
            child: Text(
              'No hay mediciones disponibles para esta fase.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        final List<PanelItem> chartPanels =
            viewModel.measurementsByParameter.entries.map((entry) {
          final parameterName = entry.key;
          final measurementsForParameter = entry.value;

          final unitOfMeasurement = measurementsForParameter.isNotEmpty
              ? measurementsForParameter.first.unitOfMeasurement
              : '';

          return PanelItem(
            iconPath: IconUtils.getIconForParameter(
                parameterName), // Usa IconUtils para el icono
            title:
                parameterName, // El nombre del parámetro como título del panel
            body: LineChart(
              parameterName: parameterName,
              unitOfMeasurement: unitOfMeasurement,
              measurements: measurementsForParameter,
            ),
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 24.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: viewModel.measurementsByParameter.values
                      .map((measurementsList) {
                    final latestMeasurement = measurementsList.last;
                    return ParameterIcon(
                      iconPath: IconUtils.getIconForParameter(
                          latestMeasurement.parameter),
                      value: latestMeasurement.value,
                      unitOfMeasure: latestMeasurement.unitOfMeasurement,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              CustomExpansionPanelList(items: chartPanels),
            ],
          ),
        );
      },
    );
  }
}
