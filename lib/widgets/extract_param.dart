import 'package:flutter/foundation.dart';

double? extractDoubleFromParam(Uint8List frameData, Uint8List pattern) {
  try {
    //Convert the String frame to a list of Bytes
    //Try to find the pattern inside the frame
    int index = findPattern(frameData, pattern);
    if (index != -1 && index + 8 < frameData.length) {
      //When the pattern is found, retreive the next 8 Bytes
      Uint8List bytesValue = frameData.sublist(index + 4, index + 12);
      //Convert the value to double
      double paramValue =
          bytesValue.buffer.asByteData().getFloat64(0, Endian.little);
      //Avoid any false positive, if the value is outside the maximum possible range
      if (paramValue < 500000.0 && paramValue > -500000.0) {
        return (paramValue * 1000).floor() / 1000;
      } else {
        //A false positive value ?
        return null;
      }
    } else {
      //If the pattern wasn't found
      return null;
    }
  } catch (e) {
    debugPrint('An error occurred: $e');
    return null;
  }
}

int? extractIntFromParam(Uint8List frameData, Uint8List pattern) {
  try {
    //Convert the String frame to a list of Bytes
    //Try to find the pattern inside the frame
    int index = findPattern(frameData, pattern);
    if (index != -1 && index + 8 < frameData.length) {
      //When the pattern is found, retreive the next 8 Bytes
      Uint8List bytesValue = frameData.sublist(index + 4, index + 12);
      //Convert the value to int
      int paramValue =
          bytesValue.buffer.asByteData().getUint64(0, Endian.little);
      //Avoid any false positive, if the value is outside the maximum possible range
      if (paramValue < 500000 && paramValue > -500000) {
        return paramValue;
      } else {
        //A false positive value ?
        return null;
      }
    } else {
      //If the pattern wasn't found
      return null;
    }
  } catch (e) {
    debugPrint('An error occurred: $e');
    return null;
  }
}

int findPattern(Uint8List data, Uint8List pattern) {
  for (int i = 0; i < data.length - pattern.length; i++) {
    if (listEquals(data.sublist(i, i + pattern.length), pattern)) {
      return i;
    }
  }
  return -1;
}
