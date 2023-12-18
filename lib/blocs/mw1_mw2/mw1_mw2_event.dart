import 'dart:typed_data';

abstract class Mw1Mw2Event {}

class MWFrameReceived extends Mw1Mw2Event {
  final Uint8List frameData;

  MWFrameReceived(this.frameData);
}
