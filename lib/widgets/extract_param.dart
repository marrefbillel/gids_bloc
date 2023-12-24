import 'package:flutter/foundation.dart';

List<double>? extractRollAndPitch(Uint8List frameData, Uint8List pattern) {
  try {
    //Convert the String frame to a list of Bytes
    //Try to find the pattern inside the frame
    int index = findPattern(frameData, pattern);
    if (index != -1 && index + 72 < frameData.length) {
      //When the pattern is found, retreive the next 8 Bytes
      Uint8List rollBytes = frameData.sublist(index + 4, index + 12);
      Uint8List pitchBytes = frameData.sublist(index + 64, index + 72);
      //Convert the value to double
      double rollValue =
          rollBytes.buffer.asByteData().getFloat64(0, Endian.little);
      double pitchValue =
          pitchBytes.buffer.asByteData().getFloat64(0, Endian.little);
      //Avoid any false positive, if the value is outside the maximum possible range
      if (rollValue < 500000.0 &&
          rollValue > -500000.0 &&
          pitchValue < 500000.0 &&
          pitchValue > -500000.0) {
        return [
          (rollValue * 1000).floor() / 1000,
          (pitchValue * 1000).floor() / 1000
        ];
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

List<double>? extractMw1Mw2(Uint8List frameData, Uint8List pattern) {
  try {
    //Convert the String frame to a list of Bytes
    //Try to find the pattern inside the frame
    int index = findPattern(frameData, pattern);
    if (index != -1 && index + 72 < frameData.length) {
      //When the pattern is found, retreive the next 8 Bytes
      Uint8List mw1Bytes = frameData.sublist(index + 4, index + 12);
      Uint8List mw2Bytes = frameData.sublist(index + 124, index + 132);
      //Convert the value to double
      double mw1Value =
          mw1Bytes.buffer.asByteData().getFloat64(0, Endian.little);
      double mw2Value =
          mw2Bytes.buffer.asByteData().getFloat64(0, Endian.little);
      //Avoid any false positive, if the value is outside the maximum possible range
      if (mw1Value < 500000.0 &&
          mw1Value > -500000.0 &&
          mw2Value < 500000.0 &&
          mw2Value > -500000.0) {
        return [
          (mw1Value * 1000).floor() / 1000,
          (mw2Value * 1000).floor() / 1000
        ];
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

List<int>? extractSystemMode(Uint8List frameData, Uint8List pattern) {
  try {
    //Convert the String frame to a list of Bytes
    //Try to find the pattern inside the frame
    int index = findPattern(frameData, pattern);
    if (index != -1 && index + 72 < frameData.length) {
      //When the pattern is found, retreive the next 8 Bytes
      Uint8List sMBytes = frameData.sublist(index + 4, index + 12);
      Uint8List sSMBytes = frameData.sublist(index + 24, index + 32);
      //Convert the value to double
      int sMValue = sMBytes.buffer.asByteData().getUint64(0, Endian.little);
      int sSM2Value = sSMBytes.buffer.asByteData().getUint64(0, Endian.little);
      //Avoid any false positive, if the value is outside the maximum possible range
      if (sMValue < 500000 &&
          sMValue > -500000 &&
          sSM2Value < 500000 &&
          sSM2Value > -500000) {
        return [sMValue, sSM2Value];
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
