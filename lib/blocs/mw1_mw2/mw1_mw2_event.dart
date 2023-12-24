abstract class Mw1Mw2Event {}

class MWFrameReceived extends Mw1Mw2Event {
  final List<double> mw1AndMw2;

  MWFrameReceived(this.mw1AndMw2);
}

class MWReset extends Mw1Mw2Event {}
