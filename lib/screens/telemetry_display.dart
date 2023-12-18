import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_state.dart';
import 'package:gids_bloc/datapoint.dart';
import 'package:gids_bloc/widgets/datagram_listener.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TelemetryDisplay extends StatefulWidget {
  const TelemetryDisplay({super.key});

  @override
  State<TelemetryDisplay> createState() => _TelemetryDisplayState();
}

class _TelemetryDisplayState extends State<TelemetryDisplay> {
  late final PitchRollBloc pitchRollBloc;
  late final Mw1Mw2Bloc mw1Mw2Bloc;

  @override
  void initState() {
    super.initState();
    pitchRollBloc = BlocProvider.of<PitchRollBloc>(context);
    mw1Mw2Bloc = BlocProvider.of<Mw1Mw2Bloc>(context);
    datagramListener(
      2246,
      InternetAddress("0.0.0.0"),
      true,
      multicastAddress: InternetAddress("239.0.0.5"),
      pitchRollBloc: pitchRollBloc,
      mw1Mw2Bloc: mw1Mw2Bloc,
    );
  }

  @override
  void dispose() {
    pitchRollBloc.close();
    mw1Mw2Bloc.close();
    super.dispose();
  }

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
      body: Column(
        children: [
          BlocBuilder<PitchRollBloc, PitchRollState>(builder: (context, state) {
            debugPrint('Building with state: $state');
            if (state is PitchRollReceived) {
              return SizedBox(
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
              );
            } else {
              return const Center(child: Text('Waiting for data...'));
            }
          })
        ],
      ),
    );
  }
}
