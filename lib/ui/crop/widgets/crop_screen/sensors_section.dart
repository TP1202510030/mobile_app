import 'package:flutter/material.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
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
          final parameter = entry.key;
          final measurementsForParameter = entry.value;

          final unitOfMeasurement = measurementsForParameter.isNotEmpty
              ? measurementsForParameter.first.unitOfMeasurement
              : '';

          return PanelItem(
            iconPath: parameter.iconPath,
            title: parameter.label,
            body: LineChart(
              parameterName: parameter.label,
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
                    // ✅ CAMBIO: Convierte la clave String al enum antes de usar.
                    final parameterEnum =
                        ParameterInfo.fromKey(latestMeasurement.parameter);
                    return ParameterIcon(
                      iconPath: parameterEnum.iconPath,
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
