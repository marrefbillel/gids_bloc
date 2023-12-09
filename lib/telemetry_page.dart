import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/datapoint.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gids_bloc/blocs/telemetry_bloc.dart';
import 'package:gids_bloc/blocs/telemetry_state.dart';

class TelemetryPage extends StatelessWidget {
  const TelemetryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TrackballBehavior trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    final ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
    );
    return Scaffold(
      body: BlocBuilder<TelemetryBloc, InformationState>(
        builder: (context, state) {
          return Column(
            children: [
              // Add the chart at the top of the page
              SizedBox(
                width: 700,
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.Hms(),
                    intervalType: DateTimeIntervalType.seconds,
                  ),
                  series: <ChartSeries>[
                    FastLineSeries<DataPoint, DateTime>(
                        dataSource: state.dataPoints,
                        xValueMapper: (DataPoint dp, _) =>
                            DateTime.fromMillisecondsSinceEpoch(
                                (dp.xVal * 1000).round()),
                        yValueMapper: (DataPoint dp, _) => dp.pitchVal,
                        name: 'Pitch'),
                    FastLineSeries<DataPoint, DateTime>(
                        dataSource: state.dataPoints,
                        xValueMapper: (DataPoint dp, _) =>
                            DateTime.fromMillisecondsSinceEpoch(
                                (dp.xVal * 1000).round()),
                        yValueMapper: (DataPoint dp, _) => dp.rollVal,
                        name: 'Roll'),
                  ],
                  trackballBehavior: trackballBehavior,
                  zoomPanBehavior: zoomPanBehavior,
                ),
              ),
              // Add the list of information below the chart
              Expanded(
                child: ListView.builder(
                  itemCount: state.information.length,
                  itemBuilder: (context, index) {
                    String key = state.information.keys.elementAt(index);
                    return ListTile(
                      title: Text(key),
                      subtitle: Text(
                          'Current: ${state.information[key]}, Min: ${state.minValues[key]}, Max: ${state.maxValues[key]}'),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
