import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_event.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_state.dart';
import 'package:gids_bloc/datapoint.dart';

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
      try {
        if (eventQueue.length >= maxQueueSize) {
          eventQueue.removeFirst();
        }
        final roll = event.pitchAndRoll[0];
        final pitch = event.pitchAndRoll[1];
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
      } catch (e) {
        debugPrint('Error: $e');
      }
    });
    on<PRReset>((event, emit) async {
      // Reset the state of your bloc here
      // For example:
      minPitch = double.infinity;
      maxPitch = double.negativeInfinity;
      minRoll = double.infinity;
      maxRoll = double.negativeInfinity;
      dataPoints = [];
      minPitchDate = DateTime.now();
      maxPitchDate = DateTime.now();
      minRollhDate = DateTime.now();
      maxRollDate = DateTime.now();
      emit(PitchRollInitial());
    });
  }
}
