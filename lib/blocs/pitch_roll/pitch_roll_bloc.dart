import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_event.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_state.dart';
import 'package:gids_bloc/datapoint.dart';
import 'package:gids_bloc/widgets/extract_param.dart';

class PitchRollBloc extends Bloc<PitchRollEvent, PitchRollState> {
  final eventQueue = Queue<PitchRollEvent>();
  final int maxQueueSize = 500;
  double minPitch = double.infinity;
  double maxPitch = double.negativeInfinity;
  double minRoll = double.infinity;
  double maxRoll = double.negativeInfinity;
  List<DataPoint> dataPoints = [];
  DateTime minPitchDate = DateTime.now();
  DateTime maxPitchDate = DateTime.now();
  DateTime minRollhDate = DateTime.now();
  DateTime maxRollDate = DateTime.now();

  PitchRollBloc() : super(PitchRollInitial()) {
    on<PRFrameReceived>((event, emit) async {
      if (eventQueue.length >= maxQueueSize) {
        eventQueue.removeFirst();
      }
      // eventQueue.add(event);
      // for (var value in eventQueue) {
      //   if (value is PRFrameReceived) {
      //     debugPrint(value.frameData.toString());
      //   }
      // }
      //final pitch = extractPitch(event.frameData);
      final pitch = extractDoubleFromParam(
          event.frameData, Uint8List.fromList([80, 20, 0, 0]));
      final roll = extractDoubleFromParam(
          event.frameData, Uint8List.fromList([77, 20, 0, 0]));
      //final roll = extractRoll(event.frameData);
      if (pitch != null && roll != null) {
        if (pitch < minPitch) {
          minPitch = pitch;
          minPitchDate = DateTime.now();
        }
        if (pitch > maxPitch) {
          maxPitch = pitch;
          maxPitchDate = DateTime.now();
        }
        if (roll < minRoll) {
          minRoll = roll;
          minRollhDate = DateTime.now();
        }
        if (roll > maxRoll) {
          maxRoll = roll;
          maxRollDate = DateTime.now();
        }
        //minPitch = min(minPitch, pitch);
        // maxPitch = max(maxPitch, pitch);
        // minRoll = min(minRoll, roll);
        // maxRoll = max(maxRoll, roll);
        dataPoints.add(DataPoint(
            DateTime.now().millisecondsSinceEpoch / 1000, pitch, roll));
        if (dataPoints.length > 20000) {
          dataPoints.removeAt(0);
        }
        emit(PitchRollReceived(
            pitch,
            roll,
            minPitch,
            maxPitch,
            minRoll,
            maxRoll,
            dataPoints,
            minPitchDate,
            maxPitchDate,
            minRollhDate,
            maxRollDate));
      }
    });
  }
}
