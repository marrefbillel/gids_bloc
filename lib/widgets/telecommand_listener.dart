import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_bloc.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_event.dart';
import 'package:gids_bloc/widgets/log_to_file.dart';

Future<StreamSubscription<RawSocketEvent>> telecommandListener(
    int udpPort, dynamic internetAddress,
    {required TelecommandBloc telecommandBloc}) async {
  final serverAddress = InternetAddress('0.0.0.0');
  try {
    final datagramSocket = await RawDatagramSocket.bind(serverAddress, udpPort);

    return datagramSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = datagramSocket.receive();
        if (datagram == null) return;
        if (datagram.data.length > 11 && datagram.data[1] == 246) {
          if (datagram.data[11] == 2) {
            Uint8List tempList = datagram.data.sublist(54, 57);

            if (listEquals(tempList, Uint8List.fromList([59, 25, 57]))) {
              if (datagram.data[8] == 130) {
                DateTime date = DateTime.now();
                String command =
                    "K18 Sent From Bouchaoui at: ${date.toString()}";
                telecommandBloc.add(TCFrameReceived(command));
              } else if (datagram.data[8] == 132) {
                DateTime date = DateTime.now();
                String command =
                    "K18 Sent From Boughezzoul at: ${date.toString()}";
                telecommandBloc.add(TCFrameReceived(command));
              } else {
                DateTime date = DateTime.now();
                String command = "K18 Sent at: ${date.toString()}";
                telecommandBloc.add(TCFrameReceived(command));
              }
            }
          }
        }
        //}
      }
    });
  } catch (e) {
    logToFile('Error: $e');
    rethrow;
  }
}
