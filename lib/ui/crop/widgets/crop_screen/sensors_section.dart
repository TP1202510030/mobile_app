import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';
import 'package:mobile_app/ui/crop/ui/expansion_panel_list.dart';
import 'package:mobile_app/ui/crop/ui/line_chart.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorsSection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  final ActiveCropSuccess state;

  const SensorsSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isPhaseDataLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.measurementsForSelectedPhase.isEmpty) {
      return const EmptyState(
        message: 'No hay mediciones para mostrar en esta fase.',
        iconAsset: AppIcons.sensor,
      );
    }

    final latestMeasurements = viewModel.measurementsByParameter.values
        .where((list) => list.isNotEmpty)
        .map((list) => list.last)
        .toList();

    final chartPanels = viewModel.measurementsByParameter.entries
        .map((entry) => PanelItem(
              id: entry.key.name,
              iconPath: entry.key.iconPath,
              title: entry.key.label,
              body: LineChart(
                parameterName: entry.key.label,
                points: entry.value
                    .map((m) => LineChartDataPoint(x: m.timestamp, y: m.value))
                    .toList(),
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ))
        .toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          if (state.isCurrentActivePhase) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                  horizontal: AppSizes.spacingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: latestMeasurements
                    .map((m) => ParameterIcon(measurement: m))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          CustomExpansionPanelList(items: chartPanels),
        ],
      ),
    );
  }
}
