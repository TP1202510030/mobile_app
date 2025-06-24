import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class LineChart extends StatelessWidget {
  final String parameterName;
  final String unitOfMeasurement;
  final List<Measurement> measurements;
  final TooltipBehavior tooltipBehavior;

  const LineChart({
    super.key,
    required this.parameterName,
    required this.unitOfMeasurement,
    required this.measurements,
    required this.tooltipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      // ... (sin cambios aquí)
    }

    List<Measurement> chartMeasurements = [];
    if (measurements.length == 1) {
      // ... (sin cambios aquí)
    } else {
      chartMeasurements = measurements;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2.0,
        ),
      ),
      child: SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.hours,
              interval: 4,
              dateFormat: DateFormat.Hm(),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: tooltipBehavior,
            series: <CartesianSeries<Measurement, DateTime>>[
              LineSeries<Measurement, DateTime>(
                dataSource: chartMeasurements,
                xValueMapper: (Measurement data, _) => data.timestamp.toLocal(),
                yValueMapper: (Measurement data, _) => data.value,
                name: parameterName,
                color: Theme.of(context).colorScheme.primary,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                // ✅ CAMBIO: Se añade esta línea para deshabilitar la animación de dibujado.
                animationDuration: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
