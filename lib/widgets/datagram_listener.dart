import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_event.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_event.dart';
import 'package:gids_bloc/widgets/hex_to_byte.dart';

Future<void> datagramListener(
    int udpPort, dynamic internetAddress, bool isMulticat,
    {dynamic multicastAddress,
    required PitchRollBloc pitchRollBloc,
    required Mw1Mw2Bloc mw1Mw2Bloc}) async {
  final serverAddress = InternetAddress('0.0.0.0');
  try {
    final datagramSocket = await RawDatagramSocket.bind(serverAddress, udpPort);
    debugPrint('Listening for UDP data on port $udpPort...');
    if (isMulticat) {
      datagramSocket.joinMulticast(multicastAddress);
    }
    datagramSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = datagramSocket.receive();
        if (datagram == null) return;

        // Convert the data to a hexadecimal string
        Uint8List bid = datagram.data.sublist(10, 14);
        if (listEquals(bid, [16, 04, 240, 96])) {
          if (datagram.data[24] == 4 ||
              datagram.data[24] == 5 ||
              datagram.data[24] == 6 ||
              datagram.data[24] == 7 ||
              datagram.data[24] == 8 ||
              datagram.data[24] == 18) {
            String hexString = datagram.data
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join(' ');
            Uint8List hexData = hexToBytes(hexString.replaceAll(' ', ''));
            pitchRollBloc.add(PRFrameReceived(hexData));
            mw1Mw2Bloc.add(MWFrameReceived(hexData));
          }
        }
      }
    });
  } catch (e) {
    debugPrint('Error: $e');
  }
}
