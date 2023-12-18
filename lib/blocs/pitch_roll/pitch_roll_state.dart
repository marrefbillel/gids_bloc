import 'package:gids_bloc/datapoint.dart';

abstract class PitchRollState {}

class PitchRollInitial extends PitchRollState {}

class PitchRollReceived extends PitchRollState {
  final double pitch;
  final double roll;
  final double minPitch;
  final double maxPitch;
  final double minRoll;
  final double maxRoll;
  final List<DataPoint> dataPoints;

  PitchRollReceived(this.pitch, this.roll, this.minPitch, this.maxPitch,
      this.minRoll, this.maxRoll, this.dataPoints);
}
