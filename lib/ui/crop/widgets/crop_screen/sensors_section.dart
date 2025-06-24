import 'package:flutter/material.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/crop/ui/expansion_panel_list.dart';
import 'package:mobile_app/ui/crop/ui/line_chart.dart';
import 'package:mobile_app/ui/crop/view_models/crop_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorsSection extends StatefulWidget {
  final CropViewModel viewModel;

  const SensorsSection({super.key, required this.viewModel});

  @override
  State<SensorsSection> createState() => _SensorsSectionState();
}

class _SensorsSectionState extends State<SensorsSection> {
  Map<Parameter, TooltipBehavior> _tooltipBehaviors = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.isLoadingMeasurements) {
          return const Center(child: CircularProgressIndicator());
        }
        if (widget.viewModel.measurementError != null) {
          return Center(
            child: Text(
              'Error: ${widget.viewModel.measurementError}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (widget.viewModel.measurementsByParameter.isEmpty) {
          return Center(
            child: Text(
              'No hay mediciones disponibles para esta fase.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        for (var param in widget.viewModel.measurementsByParameter.keys) {
          _tooltipBehaviors.putIfAbsent(
              param, () => TooltipBehavior(enable: true));
        }

        final List<PanelItem> chartPanels =
            widget.viewModel.measurementsByParameter.entries.map((entry) {
          final parameter = entry.key;
          final measurementsForParameter = entry.value;

          final unitOfMeasurement = measurementsForParameter.isNotEmpty
              ? measurementsForParameter.first.unitOfMeasurement
              : '';

          final tooltipBehavior = _tooltipBehaviors[parameter]!;

          return PanelItem(
            iconPath: parameter.iconPath,
            title: parameter.label,
            tooltipBehavior: tooltipBehavior,
            body: LineChart(
              parameterName: parameter.label,
              unitOfMeasurement: unitOfMeasurement,
              measurements: measurementsForParameter,
              tooltipBehavior: tooltipBehavior,
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
                  children: widget.viewModel.measurementsByParameter.values
                      .map((measurementsList) {
                    final latestMeasurement = measurementsList.last;

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
