import 'dart:typed_data';

abstract class PitchRollEvent {}

class PRFrameReceived extends PitchRollEvent {
  final Uint8List frameData;

  PRFrameReceived(this.frameData);
}
