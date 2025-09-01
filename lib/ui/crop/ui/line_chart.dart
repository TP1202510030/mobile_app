import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

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
              interval: 4,
              dateFormat: DateFormat.Hm(),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: tooltipBehavior,
            series: <CartesianSeries<LineChartDataPoint, DateTime>>[
              LineSeries<LineChartDataPoint, DateTime>(
                dataSource: points,
                xValueMapper: (LineChartDataPoint point, _) =>
                    point.x.toLocal(),
                yValueMapper: (LineChartDataPoint point, _) => point.y,
                name: parameterName,
                color: Theme.of(context).colorScheme.primary,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                animationDuration: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
