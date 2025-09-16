import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

@immutable
class LineChartDataPoint {
  final DateTime x;
  final double y;

  const LineChartDataPoint({required this.x, required this.y});
}

class LineChart extends StatelessWidget {
  final String parameterName;
  final List<LineChartDataPoint> points;
  final TooltipBehavior tooltipBehavior;

  const LineChart({
    super.key,
    required this.parameterName,
    required this.points,
    required this.tooltipBehavior,
  });

  static const Duration _startPointOffset = Duration(hours: 4);

  List<LineChartDataPoint> _getChartPoints() {
    if (points.length == 1) {
      final singlePoint = points.first;
      final startPoint = LineChartDataPoint(
        x: singlePoint.x.subtract(_startPointOffset),
        y: 0,
      );
      return [startPoint, singlePoint];
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return points.isEmpty ? _buildEmptyState(context) : _buildChart(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No hay datos disponibles para $parameterName',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final chartPoints = _getChartPoints();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2.0,
        ),
      ),
      child: SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.hours,
              interval: 8,
              dateFormat: DateFormat.Hm(),
              majorGridLines: const MajorGridLines(width: 1),
              axisLabelFormatter: (args) => ChartAxisLabel('', null),
            ),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: tooltipBehavior,
            series: <CartesianSeries<LineChartDataPoint, DateTime>>[
              LineSeries<LineChartDataPoint, DateTime>(
                dataSource: chartPoints,
                xValueMapper: (LineChartDataPoint point, _) =>
                    point.x.toLocal(),
                yValueMapper: (LineChartDataPoint point, _) => point.y,
                name: parameterName,
                color: Theme.of(context).colorScheme.primary,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    if (chartPoints.length == 2 && pointIndex == 0) {
                      return const SizedBox.shrink();
                    }
                    return Text(data.y.toStringAsFixed(1));
                  },
                ),
                animationDuration: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
