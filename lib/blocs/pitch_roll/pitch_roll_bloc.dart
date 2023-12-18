import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_event.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_state.dart';
import 'package:gids_bloc/datapoint.dart';
import 'package:gids_bloc/widgets/extract_param.dart';

class PitchRollBloc extends Bloc<PitchRollEvent, PitchRollState> {
  double minPitch = double.infinity;
  double maxPitch = double.negativeInfinity;
  double minRoll = double.infinity;
  double maxRoll = double.negativeInfinity;
  List<DataPoint> dataPoints = [];

  PitchRollBloc() : super(PitchRollInitial()) {
    on<PRFrameReceived>((event, emit) async {
      debugPrint('Processing PRFrameReceived event: $event');
      //final pitch = extractPitch(event.frameData);
      final pitch =
          extractParam(event.frameData, Uint8List.fromList([80, 20, 0, 0]), 0);
      final roll =
          extractParam(event.frameData, Uint8List.fromList([77, 20, 0, 0]), 0);
      //final roll = extractRoll(event.frameData);
      if (pitch != null && roll != null) {
        minPitch = min(minPitch, pitch);
        maxPitch = max(maxPitch, pitch);
        minRoll = min(minRoll, roll);
        maxRoll = max(maxRoll, roll);
        dataPoints.add(DataPoint(
            DateTime.now().millisecondsSinceEpoch / 1000, pitch, roll));
        if (dataPoints.length > 20000) {
          dataPoints.removeAt(0);
        }
        debugPrint('Emitting state: $state');
        emit(PitchRollReceived(
            pitch, roll, minPitch, maxPitch, minRoll, maxRoll, dataPoints));
      }
    });
  }
}
