import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_event.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_event.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_bloc.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_event.dart';
import 'package:gids_bloc/widgets/extract_param.dart';
import 'package:gids_bloc/widgets/hex_to_byte.dart';

Future<StreamSubscription<RawSocketEvent>> datagramListener(
    int udpPort, dynamic internetAddress, bool isMulticat,
    {dynamic multicastAddress,
    required PitchRollBloc pitchRollBloc,
    required Mw1Mw2Bloc mw1Mw2Bloc,
    required SystemModeBloc systemModeBloc}) async {
  final serverAddress = InternetAddress('0.0.0.0');
  try {
    final datagramSocket = await RawDatagramSocket.bind(serverAddress, udpPort);
    debugPrint('Listening for UDP data on port $udpPort...');
    if (isMulticat) {
      datagramSocket.joinMulticast(multicastAddress);
    }
    return datagramSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = datagramSocket.receive();
        if (datagram == null) return;

        // Convert the data to a hexadecimal string
        Uint8List bid = datagram.data.sublist(10, 14);
        if (listEquals(bid, [01, 02, 224, 96])) {
          if (datagram.data[24] == 60) {
            String hexString = datagram.data
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join(' ');
            Uint8List hexData = hexToBytes(hexString.replaceAll(' ', ''));
            List<int>? sMResults =
                extractSystemMode(hexData, Uint8List.fromList([103, 20, 2, 0]));
            if (sMResults != null) {
              if (!systemModeBloc.isClosed) {
                systemModeBloc.add(SMFrameReceived(sMResults));
              }
            }
          }
        } else if (listEquals(bid, [16, 04, 240, 96])) {
          // if (datagram.data[24] == 4 ||
          //     datagram.data[24] == 5 ||
          //     datagram.data[24] == 6 ||
          //     datagram.data[24] == 7 ||
          //     datagram.data[24] == 8 ||
          //     datagram.data[24] == 18) {
          debugPrint(datagram.data[24].toString());
          String hexString = datagram.data
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(' ');
          Uint8List hexData = hexToBytes(hexString.replaceAll(' ', ''));
          List<double>? pitchRollResults =
              extractRollAndPitch(hexData, Uint8List.fromList([77, 20, 0, 0]));
          if (pitchRollResults != null) {
            if (!pitchRollBloc.isClosed) {
              pitchRollBloc.add(PRFrameReceived(pitchRollResults));
            }
          }
          List<double>? mw1Mw2Results =
              extractMw1Mw2(hexData, Uint8List.fromList([62, 20, 0, 0]));
          if (mw1Mw2Results != null) {
            if (!mw1Mw2Bloc.isClosed) {
              mw1Mw2Bloc.add(MWFrameReceived(mw1Mw2Results));
            }
          }
          List<int>? sMResults =
              extractSystemMode(hexData, Uint8List.fromList([103, 20, 2, 0]));
          if (sMResults != null) {
            if (!systemModeBloc.isClosed) {
              systemModeBloc.add(SMFrameReceived(sMResults));
            }
          }
        }
        //}
      }
    });
  } catch (e) {
    debugPrint('Error: $e');
    rethrow;
  }
}
