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
    Size size = MediaQuery.of(context).size;
    final TrackballBehavior trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: ChartAlignment.near,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    final ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
    );

    return Scaffold(
      body: BlocBuilder<TelemetryBloc, InformationState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Pitch & Roll Graph",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Add the chart at the top of the page
              SizedBox(
                width: size.width * .8,
                height: 300,
                child: GestureDetector(
                  onSecondaryTap: () => zoomPanBehavior.reset(),
                  child: state.dataPoints.isNotEmpty
                      ? SfCartesianChart(
                          plotAreaBackgroundColor:
                              const Color.fromARGB(255, 45, 44, 44),
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.Hms(),
                            intervalType: DateTimeIntervalType.seconds,
                          ),
                          legend:
                              const Legend(isVisible: true, isResponsive: true),
                          series: <ChartSeries>[
                            FastLineSeries<DataPoint, DateTime>(
                              animationDuration: 0,
                              dataSource: state.dataPoints,
                              xValueMapper: (DataPoint dp, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (dp.xVal * 1000).round()),
                              yValueMapper: (DataPoint dp, _) => dp.pitchVal,
                              name: 'Pitch',
                            ),
                            FastLineSeries<DataPoint, DateTime>(
                              animationDuration: 0,
                              dataSource: state.dataPoints,
                              xValueMapper: (DataPoint dp, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (dp.xVal * 1000).round()),
                              yValueMapper: (DataPoint dp, _) => dp.rollVal,
                              name: 'Roll',
                            ),
                          ],
                          trackballBehavior: trackballBehavior,
                          zoomPanBehavior: zoomPanBehavior,
                        )
                      : const Center(
                          child: Text("No data to Plot"),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Telemetry Values",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Add the list of information below the chart
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width * .15,
                            height: size.height * .08,
                          ), // Empty SizedBox for alignment
                          valueTitle(size, 'Current'),
                          valueTitle(size, 'Min'),
                          valueTitle(size, 'Max'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.information.length,
                        itemBuilder: (context, index) {
                          String key = state.information.keys.elementAt(index);
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: size.width * .15,
                                    height: size.height * .08,
                                    child: Text(
                                      key,
                                      style: TextStyle(
                                        fontSize: size.height * .04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  valueContainer(
                                      size, '${state.information[key]}'),
                                  valueContainer(
                                      size, '${state.minValues[key]}'),
                                  valueContainer(
                                      size, '${state.maxValues[key]}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget valueContainer(Size size, String value) {
  return Container(
    width: size.width * .15,
    height: size.height * .08,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        value,
        style: TextStyle(fontSize: size.height * .04),
      ),
    ),
  );
}

Widget valueTitle(Size size, String title) {
  return SizedBox(
    width: size.width * .15,
    height: size.height * .08,
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size.height * .04,
      ),
    ),
  );
}
