import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

Future<StreamSubscription<RawSocketEvent>> udpListener(int udpPort,
    StreamController<int> dataStreamController, dynamic internetAddress) async {
  final serverAddress = InternetAddress('0.0.0.0');
  try {
    final datagramSocket = await RawDatagramSocket.bind(serverAddress, udpPort);
    debugPrint('Listening for UDP data on port $udpPort...');
    return datagramSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = datagramSocket.receive();
        if (datagram == null) return;

        int lastByte = datagram.data.last;
        if (!dataStreamController.isClosed) {
          dataStreamController.add(lastByte);
        }
      }
      //}
    });
  } catch (e) {
    debugPrint('Error: $e');
    rethrow;
  }
}
