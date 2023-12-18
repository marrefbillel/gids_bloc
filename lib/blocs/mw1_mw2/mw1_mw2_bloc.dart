import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_event.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_state.dart';
import 'package:gids_bloc/widgets/extract_param.dart';

class Mw1Mw2Bloc extends Bloc<Mw1Mw2Event, Mw1Mw2State> {
  double minMw1Speed = double.infinity;
  double maxMw1Speed = double.negativeInfinity;
  double minMw2Speed = double.infinity;
  double maxMw2Speed = double.negativeInfinity;

  Mw1Mw2Bloc() : super(Mw1Mw2Initial()) {
    on<MWFrameReceived>((event, emit) async {
      //final pitch = extractPitch(event.frameData);
      final mw1Speed =
          extractParam(event.frameData, Uint8List.fromList([62, 20, 0, 0]), 0);
      final mw2Speed =
          extractParam(event.frameData, Uint8List.fromList([205, 20, 0, 0]), 0);
      //final roll = extractRoll(event.frameData);
      if (mw1Speed != null && mw2Speed != null) {
        minMw1Speed = min(minMw1Speed, mw1Speed);
        maxMw1Speed = max(maxMw1Speed, mw1Speed);
        minMw2Speed = min(minMw2Speed, mw2Speed);
        maxMw2Speed = max(maxMw2Speed, mw2Speed);
        emit(Mw1Mw2Received(mw1Speed, mw2Speed, minMw1Speed, maxMw1Speed,
            minMw2Speed, maxMw2Speed));
      }
    });
  }
}
