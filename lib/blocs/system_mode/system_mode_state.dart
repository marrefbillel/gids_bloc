abstract class SystemModeState {}

final class SystemModeInitial extends SystemModeState {}

class SystemModeReceived extends SystemModeState {
  final int mode;
  final int subMode;

  SystemModeReceived(this.mode, this.subMode);
}
