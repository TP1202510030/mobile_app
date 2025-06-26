import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';
import 'package:mobile_app/domain/models/grow_room/parameter.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';

import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';

class FinishedCropDetailsScreen extends StatelessWidget {
  final FinishedCropDetailViewModel viewModel;
  final String totalProduction;

  const FinishedCropDetailsScreen({
    super.key,
    required this.viewModel,
    required this.totalProduction,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text(viewModel.error!));
        }

        if (viewModel.crop == null || viewModel.measurementsByDate.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.home,
                width: 64.0,
                height: 64.0,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'No hay historial para mostrar',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        }

        final sortedDates = viewModel.measurementsByDate.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Producción total: $totalProduction',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Historial',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: sortedDates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  final measurementsForDate =
                      viewModel.measurementsByDate[date]!;
                  return _DateSection(
                    date: date,
                    measurements: measurementsForDate,
                  );
                },
              ),
            ),
          ],
        );
      },
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
      groupedByTime
          .putIfAbsent(measurement.timestamp, () => [])
          .add(measurement);
    }

    final sortedTimes = groupedByTime.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd/MM/yyyy').format(date),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sortedTimes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final time = sortedTimes[index];
            final measurementsForTime = groupedByTime[time]!;
            return _HistoryCard(
              time: time,
              measurements: measurementsForTime,
            );
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
    final timeFormatter = DateFormat('h:mm a', 'es');

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeFormatter.format(time.toLocal()).toLowerCase(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: measurements.map((m) {
              return ParameterIcon(
                iconPath: ParameterInfo.fromKey(m.parameter).iconPath,
                value: m.value,
                unitOfMeasure: m.unitOfMeasurement,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
