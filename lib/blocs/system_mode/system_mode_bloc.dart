import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_event.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_state.dart';
import 'package:gids_bloc/widgets/extract_param.dart';

class SystemModeBloc extends Bloc<SystemModeEvent, SystemModeState> {
  final eventQueue = Queue<SystemModeEvent>();
  final int maxQueueSize = 200;

  SystemModeBloc() : super(SystemModeInitial()) {
    on<SMFrameReceived>((event, emit) {
      if (eventQueue.length >= maxQueueSize) {
        eventQueue.removeFirst();
      }
      final mode = extractIntFromParam(
          event.frameData, Uint8List.fromList([103, 20, 2, 0]));
      final submode = extractIntFromParam(
          event.frameData, Uint8List.fromList([104, 20, 2, 0]));
      if (mode != null && submode != null) {
        emit(SystemModeReceived(mode, submode));
      }
    });
  }
}
