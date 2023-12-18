import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/datapoint.dart';
import 'telemetry_event.dart';
import 'telemetry_state.dart';

class TelemetryBloc extends Bloc<FrameEvent, InformationState> {
  Map<Uint8List, String> indices = {
    Uint8List.fromList([80, 20, 0, 0]): 'Pitch',
    Uint8List.fromList([77, 20, 0, 0]): 'Roll',
    Uint8List.fromList([62, 20, 0, 0]): 'MW1 speed',
    Uint8List.fromList([205, 20, 0, 0]): 'MW2 speed',
  };

  static Uint8List hexToBytes(String hex) {
    hex = hex.replaceAll(' ', '');
    return Uint8List.fromList(List<int>.generate(hex.length ~/ 2,
        (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)));
  }

  Map<String, double> minValues = {
    'Pitch': double.infinity,
    'Roll': double.infinity,
    'MW2 speed': double.infinity,
    'MW2': double.infinity,
    // Add other variables as needed
  };

  Map<String, double> maxValues = {
    'Pitch': double.negativeInfinity,
    'Roll': double.negativeInfinity,
    'MW2 speed': double.negativeInfinity,
    'MW2': double.negativeInfinity,
    // Add other variables as needed
  };

  final int bufferSize = 1000; // Define the buffer size
  final Queue<FrameEvent> buffer = Queue<FrameEvent>(); // Stores FrameEvents
  List<DataPoint> dataPoints = [];
  String lastPitchValue = 'Waiting...';
  String lastRollValue = 'Waiting...';

  TelemetryBloc() : super(InformationState({}, [], {}, {})) {
    on<FrameEvent>((event, emit) async {
      buffer.add(event);
      if (buffer.length > bufferSize) {
        buffer.removeFirst();
      }
      var bufferedEvent = buffer.last;
      // Process the frame data
      try {
        Map<String, String> newInformation =
            processFrame(bufferedEvent.frameData);

        // Update the results map with the new information

        // If the 'Pitch' value is found, add a new DataPoint
        if (newInformation.containsKey('Pitch') &&
            newInformation['Pitch'] != 'Waiting...' &&
            newInformation.containsKey('Roll') &&
            newInformation['Roll'] != 'Waiting...') {
          double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
          dataPoints.add(DataPoint(
              timestamp,
              double.parse(newInformation['Pitch']!),
              double.parse(newInformation['Roll']!)));

          lastPitchValue = newInformation['Pitch']!;
          lastRollValue = newInformation['Roll']!;
          if (dataPoints.length > 20000) {
            dataPoints.removeAt(0);
          }
        }
        //results.addAll(newInformation);
        emit(InformationState(results, dataPoints, minValues, maxValues));
      } catch (e) {
        debugPrint('Error in on<FrameEvent>: $e');
      }
    });

    datagramListener(
      2246,
      InternetAddress("0.0.0.0"),
      true,
      multicastAddress: InternetAddress("239.0.0.5"),
    ); // Start listening for UDP data on port 2246
  }

  Map<String, String> results = {
    'MW1 speed': 'Waiting...',
    'MW2 speed': 'Waiting...',
    'Pitch': 'Waiting...',
    'Roll': 'Waiting...',
  };

  Map<String, String> processFrame(String frameData) {
    // Convert the frame data to bytes
    Uint8List hexData = hexToBytes(frameData.replaceAll(' ', ''));

    // Initialize the results map

    // Process the hex data
    Map<String, String> decimalResults = {};
    Map<String, String> doubleResults = {};

    // Convert indices to byte arrays
    Map<Uint8List, String> byteIndices = {};
    for (Uint8List hexIndex in indices.keys) {
      byteIndices[hexIndex] = indices[hexIndex]!;
    }

    int i = 0;
    while (i < hexData.length - 4) {
      for (Uint8List byteIndex in indices.keys) {
        if (listEquals(hexData.sublist(i, i + 4), byteIndex)) {
          Uint8List valueBytes = hexData.sublist(i + 4, i + 12);
          Uint8List dataType = byteIndex.sublist(2, 4);
          if (listEquals(dataType, [2, 0])) {
            // Convert bytes to decimal
            int decimalValue =
                valueBytes.buffer.asByteData().getUint64(0, Endian.little);
            if (decimalValue < 50000 && decimalValue > -50000) {
              decimalResults[byteIndices[byteIndex]!] = decimalValue.toString();
            }
          } else if (listEquals(dataType, [0, 0])) {
            debugPrint('${(546.6435433 * 1000).floor() / 1000}');
            // Convert bytes to double
            double doubleValue =
                valueBytes.buffer.asByteData().getFloat64(0, Endian.little);
            if (doubleValue < 50000.0 && doubleValue > -50000.0) {
              doubleResults[byteIndices[byteIndex]!] =
                  doubleValue.toStringAsFixed(3);
            }
          }
          i += 11; // Skip to the next index
          break;
        }
      }
      i++;
    }

    // Update the results with the new values
    for (String name in byteIndices.values) {
      if (decimalResults.containsKey(name)) {
        results[name] = decimalResults[name]!;
      }
      if (doubleResults.containsKey(name)) {
        results[name] = doubleResults[name]!;
      }
      double? value = double.tryParse(results[name]!);
      if (value != null) {
        minValues[name] = min(minValues[name] ?? double.infinity, value);
        maxValues[name] =
            max(maxValues[name] ?? double.negativeInfinity, value);
      }
    }
    return results;
  }

  Future<void> datagramListener(
      int udpPort, dynamic internetAddress, bool isMulticat,
      {dynamic multicastAddress}) async {
    final serverAddress = InternetAddress('0.0.0.0');
    try {
      final datagramSocket =
          await RawDatagramSocket.bind(serverAddress, udpPort);
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
          //if (datagram.port == 49448) {
          if (listEquals(bid, [16, 04, 240, 96])) {
            debugPrint(datagram.data[24].toString());
            if (datagram.data[24] == 4 ||
                datagram.data[24] == 5 ||
                datagram.data[24] == 6 ||
                datagram.data[24] == 7 ||
                datagram.data[24] == 8 ||
                datagram.data[24] == 18) {
              String hexData = datagram.data
                  .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                  .join(' ');
              add(FrameEvent(hexData));
            }
          }
          //}
          // Add a new FrameEvent to the BLoC
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
