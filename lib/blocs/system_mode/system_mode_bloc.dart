import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_event.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_state.dart';

class SystemModeBloc extends Bloc<SystemModeEvent, SystemModeState> {
  final eventQueue = Queue<SystemModeEvent>();
  final int maxQueueSize = 200;

  SystemModeBloc() : super(SystemModeInitial()) {
    on<SMFrameReceived>((event, emit) {
      try {
        if (eventQueue.length >= maxQueueSize) {
          eventQueue.removeFirst();
        }
        final mode = event.systemMode[0];
        final subMode = event.systemMode[1];
        emit(SystemModeReceived(mode, subMode));
      } catch (e) {
        debugPrint("Error: $e");
      }
    });

    on<SMReset>((event, emit) async {
      emit(SystemModeInitial());
    });
  }
}
