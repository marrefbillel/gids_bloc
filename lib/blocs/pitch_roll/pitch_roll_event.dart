abstract class PitchRollEvent {}

class PRFrameReceived extends PitchRollEvent {
  final List<double> pitchAndRoll;

  PRFrameReceived(this.pitchAndRoll);
}

class PRReset extends PitchRollEvent {}
