import 'dart:typed_data';

sealed class SystemModeEvent {}

class SMFrameReceived extends SystemModeEvent {
  final Uint8List frameData;

  SMFrameReceived(this.frameData);
}
