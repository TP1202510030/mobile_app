import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/measurement/measurement.dart';

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
    final measurementsByDate = _groupMeasurementsByDate(measurements);
    final sortedDates = measurementsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      // Se usan estas físicas para que el scroll lo controle el padre (CustomScrollView)
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final measurementsForDate = measurementsByDate[date]!;
        return Container();
      },
    );
  }
}