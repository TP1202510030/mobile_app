import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class LineChart extends StatelessWidget {
  final String parameterName;
  final String unitOfMeasurement;
  final List<Measurement> measurements;

  const LineChart({
    super.key,
    required this.parameterName,
    required this.unitOfMeasurement,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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

    List<Measurement> chartMeasurements = [];
    if (measurements.length == 1) {
      final singleMeasurement = measurements.first;

      chartMeasurements.add(Measurement(
        id: -1,
        parameter: singleMeasurement.parameter,
        value: 0.0,
        unitOfMeasurement: singleMeasurement.unitOfMeasurement,
        timestamp:
            singleMeasurement.timestamp.subtract(const Duration(minutes: 1)),
        cropPhaseId: singleMeasurement.cropPhaseId,
      ));
      chartMeasurements.add(singleMeasurement);
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
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<Measurement, DateTime>>[
              LineSeries<Measurement, DateTime>(
                dataSource: chartMeasurements,
                xValueMapper: (Measurement data, _) => data.timestamp,
                yValueMapper: (Measurement data, _) => data.value,
                name: parameterName,
                color: Theme.of(context).colorScheme.primary,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
