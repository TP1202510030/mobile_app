import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';
import 'package:mobile_app/ui/crop/ui/expansion_panel_list.dart';
import 'package:mobile_app/ui/crop/ui/line_chart.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/common/phase_history_section.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorsSection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  final ActiveCropSuccess state;

  const SensorsSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  void _showHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return _HistoryBottomSheetBody(
              viewModel: viewModel,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

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
      child: GestureDetector(
        onTap: () => _showHistoryBottomSheet(context),
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
      ),
    );
  }
}

class _HistoryBottomSheetBody extends StatefulWidget {
  final ActiveCropViewModel viewModel;
  final ScrollController scrollController;

  const _HistoryBottomSheetBody({
    required this.viewModel,
    required this.scrollController,
  });

  @override
  State<_HistoryBottomSheetBody> createState() =>
      _HistoryBottomSheetBodyState();
}

class _HistoryBottomSheetBodyState extends State<_HistoryBottomSheetBody> {
  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.position.extentAfter < 300) {
      widget.viewModel.fetchMoreMeasurementsForSelectedPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<ActiveCropViewModel>(
        builder: (context, vm, _) {
          final state = vm.state as ActiveCropSuccess;
          return PhaseHistorySection(
            measurements: state.measurementsForSelectedPhase,
            isFetchingMore: state.isFetchingMoreMeasurements,
            scrollController: widget.scrollController,
          );
        },
      ),
    );
  }
}
