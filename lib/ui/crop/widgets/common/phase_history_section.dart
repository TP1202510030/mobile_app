import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/ui/parameter_icon.dart';

class PhaseHistorySection extends StatelessWidget {
  final List<Measurement> measurements;
  final bool isFetchingMore;
  final ScrollController? scrollController;

  const PhaseHistorySection({
    super.key,
    required this.measurements,
    this.isFetchingMore = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final measurementsByDate = _groupMeasurementsByDate(measurements);
    final sortedDates = measurementsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Text('Historial', style: theme.textTheme.bodyLarge),
        ),
        Divider(
          color: theme.colorScheme.outline,
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLarge,
              vertical: AppSizes.spacingMedium,
            ),
            itemCount: sortedDates.length + (isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == sortedDates.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final date = sortedDates[index];
              final measurementsForDate = measurementsByDate[date]!;
              return _DateSection(
                  date: date, measurements: measurementsForDate);
            },
          ),
        ),
      ],
    );
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
