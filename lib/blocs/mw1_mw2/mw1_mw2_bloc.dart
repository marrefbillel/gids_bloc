import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_event.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_state.dart';
import 'package:gids_bloc/datapoint.dart';

class Mw1Mw2Bloc extends Bloc<Mw1Mw2Event, Mw1Mw2State> {
  final eventQueue = Queue<Mw1Mw2Event>();
  final int maxQueueSize = 500;
  double minMw1Speed = double.infinity;
  double maxMw1Speed = double.negativeInfinity;
  double minMw2Speed = double.infinity;
  double maxMw2Speed = double.negativeInfinity;
  List<DataPoint> dataPoints = [];
  DateTime minMw1Date = DateTime.now();
  DateTime maxMw1Date = DateTime.now();
  DateTime minMw2Date = DateTime.now();
  DateTime maxMw2Date = DateTime.now();

  Mw1Mw2Bloc() : super(Mw1Mw2Initial()) {
    on<MWFrameReceived>((event, emit) async {
      try {
        if (eventQueue.length >= maxQueueSize) {
          eventQueue.removeFirst();
        }
        eventQueue.add(event);
        //final pitch = extractPitch(event.frameData);
        //final mw1Speed = extractDoubleFromParam(
        //event.frameData, Uint8List.fromList([62, 20, 0, 0]));
        //final mw2Speed = extractDoubleFromParam(
        //event.frameData, Uint8List.fromList([205, 20, 0, 0]));
        //final roll = extractRoll(event.frameData);
        final mw1Speed = event.mw1AndMw2[0];
        final mw2Speed = event.mw1AndMw2[1];

        if (mw1Speed < minMw1Speed) {
          minMw1Speed = mw1Speed;
          minMw1Date = DateTime.now();
        }
        if (mw1Speed > maxMw1Speed) {
          maxMw1Speed = mw1Speed;
          maxMw1Date = DateTime.now();
        }
        if (mw2Speed < minMw2Speed) {
          minMw2Speed = mw2Speed;
          minMw2Date = DateTime.now();
        }
        if (mw2Speed > maxMw2Speed) {
          maxMw2Speed = mw2Speed;
          maxMw2Date = DateTime.now();
        }

        dataPoints.add(DataPoint(
            DateTime.now().millisecondsSinceEpoch / 1000, mw1Speed, mw2Speed));
        if (dataPoints.length > 20000) {
          dataPoints.removeAt(0);
        }
        emit(Mw1Mw2Received(
          mw1Speed,
          mw2Speed,
          minMw1Speed,
          maxMw1Speed,
          minMw2Speed,
          maxMw2Speed,
          dataPoints,
          minMw1Date,
          maxMw1Date,
          minMw2Date,
          maxMw2Date,
        ));
      } catch (e) {
        debugPrint("Error: $e");
      }
    });
    on<MWReset>((event, emit) async {
      // Reset the state of your bloc here
      // For example:
      minMw1Speed = double.infinity;
      maxMw1Speed = double.negativeInfinity;
      minMw2Speed = double.infinity;
      maxMw2Speed = double.negativeInfinity;
      dataPoints = [];
      minMw1Date = DateTime.now();
      maxMw1Date = DateTime.now();
      minMw2Date = DateTime.now();
      maxMw2Date = DateTime.now();
      emit(Mw1Mw2Initial());
    });
  }
}
