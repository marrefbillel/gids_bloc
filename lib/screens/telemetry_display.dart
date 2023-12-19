import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_state.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_state.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_bloc.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_state.dart';
import 'package:gids_bloc/datapoint.dart';
import 'package:gids_bloc/widgets/datagram_listener.dart';
import 'package:gids_bloc/widgets/digital_clock.dart';
import 'package:gids_bloc/widgets/udp_listener.dart';
import 'package:gids_bloc/widgets/working_mode_stream.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TelemetryDisplay extends StatefulWidget {
  const TelemetryDisplay({super.key});

  @override
  State<TelemetryDisplay> createState() => _TelemetryDisplayState();
}

class _TelemetryDisplayState extends State<TelemetryDisplay> {
  final StreamController<int> bcDataStreamController = StreamController<int>();
  final StreamController<int> bgDataStreamController = StreamController<int>();
  late final PitchRollBloc pitchRollBloc;
  late final Mw1Mw2Bloc mw1Mw2Bloc;
  late final SystemModeBloc systemModeBloc;

  @override
  void initState() {
    super.initState();
    pitchRollBloc = BlocProvider.of<PitchRollBloc>(context);
    mw1Mw2Bloc = BlocProvider.of<Mw1Mw2Bloc>(context);
    systemModeBloc = BlocProvider.of<SystemModeBloc>(context);
    datagramListener(
      2246,
      InternetAddress("0.0.0.0"),
      true,
      multicastAddress: InternetAddress("239.0.0.5"),
      pitchRollBloc: pitchRollBloc,
      mw1Mw2Bloc: mw1Mw2Bloc,
      systemModeBloc: systemModeBloc,
    );
    udpListener(
      16010,
      bcDataStreamController,
      InternetAddress("0.0.0.0"),
    );
    udpListener(
      16110,
      bgDataStreamController,
      InternetAddress("0.0.0.0"),
    ); // Start listening for UDP data on port 16010
    // udpListener(
    //   16110,
    //   InternetAddress("0.0.0.0"),
    // );
  }

  @override
  void dispose() {
    pitchRollBloc.close();
    mw1Mw2Bloc.close();
    systemModeBloc.close();
    bcDataStreamController.close();
    bgDataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );

    final ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
    );
    final CrosshairBehavior crosshairBehavior = CrosshairBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      shouldAlwaysShow: true,
    );
    final TrackballBehavior trackballBehavior2 = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    final ZoomPanBehavior zoomPanBehavior2 = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
    );
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const DigitalClock(),
                BlocBuilder<SystemModeBloc, SystemModeState>(
                    builder: (context, state) {
                  if (state is SystemModeReceived) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("System mode : "),
                          const SizedBox(width: 10),
                          valueContainer(size, '${state.mode}',
                              conversionMap: {'0': 'NM', '1': 'SKM'}),
                          const SizedBox(width: 10),
                          // const Text("Subsystem mode : "),
                          // const SizedBox(width: 10),
                          // valueContainer(size, '${state.subMode}',
                          //     conversionMap: {'0': 'NM', '1': 'SKM'}),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
                WorkingModeStream(
                  dataStreamController: bcDataStreamController,
                  station: "BC",
                ),
                WorkingModeStream(
                  dataStreamController: bgDataStreamController,
                  station: "BG",
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "Pitch and Roll",
              style: TextStyle(fontSize: size.height * .03),
            ),
          ),
          BlocBuilder<PitchRollBloc, PitchRollState>(builder: (context, state) {
            if (state is PitchRollReceived) {
              return Column(
                children: [
                  SizedBox(
                    width: size.width * .8,
                    height: size.height * .2,
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
                              legend: const Legend(
                                  isVisible: true, isResponsive: true),
                              series: <ChartSeries>[
                                FastLineSeries<DataPoint, DateTime>(
                                  animationDuration: 0,
                                  dataSource: state.dataPoints,
                                  xValueMapper: (DataPoint dp, _) =>
                                      DateTime.fromMillisecondsSinceEpoch(
                                          (dp.xVal * 1000).round()),
                                  yValueMapper: (DataPoint dp, _) =>
                                      dp.pitchVal,
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
                              crosshairBehavior: crosshairBehavior,
                            )
                          : const Center(
                              child: Text("No data to Plot"),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                      ), // Empty SizedBox for alignment
                      valueTitle(size, 'Current'),
                      valueTitle(size, 'Min'),
                      valueTitle(size, 'Max'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                        child: Text(
                          "Pitch",
                          style: TextStyle(
                            fontSize: size.height * .03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      valueContainer(size, '${state.pitch}'),
                      Tooltip(
                          message: state.minPitchDate.toString(),
                          child: valueContainer(size, '${state.minPitch}')),
                      Tooltip(
                          message: state.maxPitchDate.toString(),
                          child: valueContainer(size, '${state.maxPitch}')),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                        child: Text(
                          "Roll",
                          style: TextStyle(
                            fontSize: size.height * .03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      valueContainer(size, '${state.roll}'),
                      Tooltip(
                          message: state.minRollDate.toString(),
                          child: valueContainer(size, '${state.minRoll}')),
                      Tooltip(
                          message: state.maxRollDate.toString(),
                          child: valueContainer(size, '${state.maxRoll}')),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.white54,
            thickness: 3,
          ),
          Center(
            child: Text(
              "Momentum Wheel",
              style: TextStyle(fontSize: size.height * .03),
            ),
          ),
          BlocBuilder<Mw1Mw2Bloc, Mw1Mw2State>(builder: (context, state) {
            if (state is Mw1Mw2Received) {
              return Column(
                children: [
                  SizedBox(
                    width: size.width * .8,
                    height: size.height * .2,
                    child: GestureDetector(
                      onSecondaryTap: () => zoomPanBehavior2.reset(),
                      child: state.dataPoints.isNotEmpty
                          ? SfCartesianChart(
                              plotAreaBackgroundColor:
                                  const Color.fromARGB(255, 45, 44, 44),
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat.Hms(),
                                intervalType: DateTimeIntervalType.seconds,
                              ),
                              legend: const Legend(
                                  isVisible: true, isResponsive: true),
                              series: <ChartSeries>[
                                FastLineSeries<DataPoint, DateTime>(
                                  animationDuration: 0,
                                  dataSource: state.dataPoints,
                                  xValueMapper: (DataPoint dp, _) =>
                                      DateTime.fromMillisecondsSinceEpoch(
                                          (dp.xVal * 1000).round()),
                                  yValueMapper: (DataPoint dp, _) =>
                                      dp.pitchVal,
                                  name: 'MW1 speed',
                                ),
                                FastLineSeries<DataPoint, DateTime>(
                                  animationDuration: 0,
                                  dataSource: state.dataPoints,
                                  xValueMapper: (DataPoint dp, _) =>
                                      DateTime.fromMillisecondsSinceEpoch(
                                          (dp.xVal * 1000).round()),
                                  yValueMapper: (DataPoint dp, _) => dp.rollVal,
                                  name: 'MW2 speed',
                                ),
                              ],
                              trackballBehavior: trackballBehavior2,
                              zoomPanBehavior: zoomPanBehavior2,
                            )
                          : const Center(
                              child: Text("No data to Plot"),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                      ), // Empty SizedBox for alignment
                      valueTitle(size, 'Current'),
                      valueTitle(size, 'Min'),
                      valueTitle(size, 'Max'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                        child: Text(
                          "MW1 speed",
                          style: TextStyle(
                            fontSize: size.height * .025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      valueContainer(size, '${state.mw1Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                      valueContainer(size, '${state.minMw1Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                      valueContainer(size, '${state.maxMw1Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * .12,
                        height: size.height * .05,
                        child: Text(
                          "MW2 speed",
                          style: TextStyle(
                            fontSize: size.height * .025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      valueContainer(size, '${state.mw2Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                      valueContainer(size, '${state.minMw2Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                      valueContainer(size, '${state.maxMw2Speed}',
                          lowerYellow: 4000,
                          lowerRed: 3800,
                          upperYellow: 5000,
                          upperRed: 5200),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ],
      ),
    );
  }
}

Widget valueContainer(Size size, String value,
    {double? lowerYellow,
    double? lowerRed,
    double? upperYellow,
    double? upperRed,
    Map<String, String>? conversionMap}) {
  Color color = Colors.teal;
  String displayValue = value;

  if (conversionMap != null && conversionMap.containsKey(value)) {
    // Use the conversion map if it's provided and the value is in the map
    displayValue = conversionMap[value]!;
  } else if (lowerYellow != null &&
      lowerRed != null &&
      upperYellow != null &&
      upperRed != null) {
    // Otherwise, use the thresholds to determine the color
    double val = double.parse(value);
    if (val > upperRed || val < lowerRed) {
      color = Colors.red;
    } else if (val > upperYellow || val < lowerYellow) {
      color = Colors.yellow;
    }
  }

  return Container(
    width: size.width * .12,
    height: size.height * .05,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        displayValue,
        style: TextStyle(fontSize: size.height * .03),
      ),
    ),
  );
}

Widget valueTitle(Size size, String title) {
  return SizedBox(
    width: size.width * .12,
    height: size.height * .03,
    child: Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size.height * .02,
        ),
      ),
    ),
  );
}
