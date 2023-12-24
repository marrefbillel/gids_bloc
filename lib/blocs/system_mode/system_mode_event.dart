abstract class SystemModeEvent {}

class SMFrameReceived extends SystemModeEvent {
  final List<int> systemMode;

  SMFrameReceived(this.systemMode);
}

class SMReset extends SystemModeEvent {}
