abstract class TelecommandState {}

final class TelecommandInitial extends TelecommandState {}

class TelecommandReceived extends TelecommandState {
  final String status;
  final String nextStatus;

  TelecommandReceived(this.status, this.nextStatus);
}
