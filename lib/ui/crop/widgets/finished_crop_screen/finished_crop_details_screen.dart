import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';
import 'package:provider/provider.dart';

class FinishedCropDetailsScreenWrapper extends StatelessWidget {
  final int cropId;
  final String totalProduction;

  const FinishedCropDetailsScreenWrapper({
    super.key,
    required this.cropId,
    required this.totalProduction,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<FinishedCropDetailViewModel>(param1: cropId),
      child: FinishedCropDetailsScreen(totalProduction: totalProduction),
    );
  }
}

class FinishedCropDetailsScreen extends StatefulWidget {
  final String totalProduction;

  const FinishedCropDetailsScreen({
    super.key,
    required this.totalProduction,
  });

  @override
  State<FinishedCropDetailsScreen> createState() =>
      _FinishedCropDetailsScreenState();
}

class _FinishedCropDetailsScreenState extends State<FinishedCropDetailsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<FinishedCropDetailViewModel>();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 300) {
        viewModel.fetchMoreMeasurementsForSelectedPhase();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<DateTime, List<Measurement>> _groupMeasurementsByDate(
      List<Measurement> measurements) {
    final Map<DateTime, List<Measurement>> groupedMap = {};
    for (final measurement in measurements) {
      final dateKey = DateUtils.dateOnly(measurement.timestamp.toLocal());
      (groupedMap[dateKey] ??= []).add(measurement);
    }
    return groupedMap;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FinishedCropDetailViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cultivo #${viewModel.crop?.id ?? ''}',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          if (viewModel.crop == null ||
              viewModel.selectedPhaseDetails == null) {
            return const EmptyState(
                message: "No hay historial para mostrar",
                iconAsset: AppIcons.mushroom);
          }

          final measurementsByDate =
          _groupMeasurementsByDate(viewModel.measurementsForSelectedPhase);
          final sortedDates = measurementsByDate.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return RefreshIndicator(
            onRefresh: viewModel.fetchCropHistory,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
              itemCount: 1 + sortedDates.length + (viewModel.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: AppSizes.spacingMedium),
                      Center(
                        child: Text(
                            'Producción total: ${widget.totalProduction} Tn',
                            style: theme.textTheme.bodySmall),
                      ),
                      _PhaseNavigator(viewModel: viewModel),
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.spacingLarge),
                        child:
                        Text('Historial', style: theme.textTheme.bodyLarge),
                      ),
                      Divider(
                        color: theme.colorScheme.outline,
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  );
                }
                final dateIndex = index - 1;
                if (dateIndex < sortedDates.length) {
                  final date = sortedDates[dateIndex];
                  final measurementsForDate = measurementsByDate[date]!;
                  return _DateSection(
                      date: date, measurements: measurementsForDate);
                }

                // --- Último Item: El Indicador de Carga ---
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PhaseNavigator extends StatelessWidget {
  final FinishedCropDetailViewModel viewModel;
  const _PhaseNavigator({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: viewModel.canGoBack ? viewModel.goToPreviousPhase : null,
        ),
        Expanded(
          child: Text(
            "Fase: ${viewModel.selectedPhaseDetails?.phase.name ?? ''}",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: viewModel.canGoForward ? viewModel.goToNextPhase : null,
        ),
      ],
    );
  }
}

class _DateSection extends StatelessWidget {
  final DateTime date;
  final List<Measurement> measurements;
  const _DateSection({required this.date, required this.measurements});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<Measurement>> groupedByTime = {};
    for (final measurement in measurements) {
      final preciseTimestamp = measurement.timestamp.toLocal();
      groupedByTime.putIfAbsent(preciseTimestamp, () => []).add(measurement);
    }

    final sortedTimes = groupedByTime.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
          child: Text(DateFormat('dd/MM/yyyy').format(date),
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sortedTimes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final time = sortedTimes[index];
            final measurementsForTime = groupedByTime[time]!;
            return _HistoryCard(time: time, measurements: measurementsForTime);
          },
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final DateTime time;
  final List<Measurement> measurements;
  const _HistoryCard({required this.time, required this.measurements});

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('h:mm:ss a', 'es_ES');
    final theme = Theme.of(context);

    measurements.sort((a, b) => a.parameter.index.compareTo(b.parameter.index));

    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius:
        const BorderRadius.all(Radius.circular(AppSizes.borderRadiusLarge)),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: AppSizes.cardBorderSize,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeFormatter.format(time.toLocal()).replaceAll(' ', ''),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: measurements
                  .map((m) => ParameterIcon(measurement: m))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}