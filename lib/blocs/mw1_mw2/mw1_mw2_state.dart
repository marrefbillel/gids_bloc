abstract class Mw1Mw2State {}

class Mw1Mw2Initial extends Mw1Mw2State {}

class Mw1Mw2Received extends Mw1Mw2State {
  final double mw1Speed;
  final double mw2Speed;
  final double minMw1Speed;
  final double maxMw1Speed;
  final double minMw2Speed;
  final double maxMw2Speed;

  Mw1Mw2Received(this.mw1Speed, this.mw2Speed, this.minMw1Speed,
      this.maxMw1Speed, this.minMw2Speed, this.maxMw2Speed);
}
