import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_bloc.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_event.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_state.dart';
import 'package:gids_bloc/widgets/telecommand_listener.dart';

class NorthSouth extends StatefulWidget {
  const NorthSouth({super.key});

  @override
  State<NorthSouth> createState() => _NorthSouthState();
}

class _NorthSouthState extends State<NorthSouth> {
  TelecommandBloc? telecommandBloc;
  StreamSubscription<RawSocketEvent>? tcSubscriptionBC;
  StreamSubscription<RawSocketEvent>? tcSubscriptionBG;

  void startTCListenerBC() async {
    tcSubscriptionBC = await telecommandListener(
      16011,
      InternetAddress("0.0.0.0"),
      telecommandBloc: telecommandBloc!,
    );
  }

  void startTCListenerBG() async {
    tcSubscriptionBG = await telecommandListener(
      16111,
      InternetAddress("0.0.0.0"),
      telecommandBloc: telecommandBloc!,
    );
  }

  void stopTCListenerBC() {
    tcSubscriptionBC?.cancel();
    tcSubscriptionBC = null;
  }

  void stopTCListenerBG() {
    tcSubscriptionBG?.cancel();
    tcSubscriptionBG = null;
  }

  @override
  void initState() {
    super.initState();
    telecommandBloc ??= BlocProvider.of<TelecommandBloc>(context);
    startTCListenerBC();
    startTCListenerBG();
  }

  @override
  void dispose() {
    stopTCListenerBC();
    stopTCListenerBG();
    telecommandBloc!.add(TCReset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: BlocBuilder<TelecommandBloc, TelecommandState>(
        builder: (context, state) {
      if (state is TelecommandReceived) {
        return Text(
          state.status,
          style: const TextStyle(fontSize: 28),
        );
      } else {
        return const Text(
          "Waiting for telecommands...",
          style: TextStyle(fontSize: 28),
        );
      }
    }));
  }
}
