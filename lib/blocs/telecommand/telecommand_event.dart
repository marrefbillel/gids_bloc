abstract class TelecommandEvent {}

class TCFrameReceived extends TelecommandEvent {
  final String command;

  TCFrameReceived(this.command);
}

class TCReset extends TelecommandEvent {}
