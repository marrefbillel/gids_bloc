import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_event.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_state.dart';
import 'package:gids_bloc/widgets/log_to_file.dart';

class TelecommandBloc extends Bloc<TelecommandEvent, TelecommandState> {
  final eventQueue = Queue<TelecommandEvent>();
  final int maxQueueSize = 200;

  TelecommandBloc() : super(TelecommandInitial()) {
    on<TCFrameReceived>((event, emit) {
      logToFile("bloc Called");
      try {
        if (eventQueue.length >= maxQueueSize) {
          eventQueue.removeFirst();
        }
        final status = event.command;
        final subMode = event.command;
        emit(TelecommandReceived(status, subMode));
      } catch (e) {
        debugPrint("Error: $e");
      }
    });
    on<TCReset>((event, emit) async {
      emit(TelecommandInitial());
    });
  }
}
