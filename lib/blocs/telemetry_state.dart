import 'package:gids_bloc/datapoint.dart';

class InformationState {
  final Map<String, String> information;
  final List<DataPoint> dataPoints;
  final Map<String, double> minValues;
  final Map<String, double> maxValues;

  InformationState(
      this.information, this.dataPoints, this.minValues, this.maxValues);
}
