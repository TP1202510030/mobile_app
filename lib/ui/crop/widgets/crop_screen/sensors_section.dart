import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/crop/ui/expansion_panel_list.dart';
import 'package:mobile_app/ui/crop/ui/line_chart.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorsSection extends StatefulWidget {
  final ActiveCropViewModel viewModel;

  const SensorsSection({super.key, required this.viewModel});

  @override
  State<SensorsSection> createState() => _SensorsSectionState();
}

class _SensorsSectionState extends State<SensorsSection> {
  final Map<Parameter, TooltipBehavior> _tooltipBehaviors = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.isLoadingMeasurements &&
            widget.viewModel.measurementsByParameter.isEmpty) {
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

        return RefreshIndicator(
          onRefresh: widget.viewModel.refreshData,
          child: _buildContent(context),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.viewModel.measurementsByParameter.isEmpty) {
      return Stack(
        children: [
          ListView(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.sensor,
                  width: 64.0,
                  height: 64.0,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'No hay mediciones para mostrar',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Lógica para los tooltips y paneles
    for (var param in widget.viewModel.measurementsByParameter.keys) {
      _tooltipBehaviors.putIfAbsent(param, () => TooltipBehavior(enable: true));
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
      physics: const AlwaysScrollableScrollPhysics(),
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
                if (measurementsList.isEmpty) return const SizedBox.shrink();
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
  }
}
