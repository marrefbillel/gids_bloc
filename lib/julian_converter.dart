import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JulianConveter extends StatelessWidget {
  const JulianConveter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(j2000ToDateTime(2334296947.712)),
    );
  }
}

String j2000ToDateTime(double j2000) {
  // J2000 epoch starts at 2000-01-01 12:00:00 TT (Terrestrial Time)
  DateTime dateTime = julianToDateTime(j2000);
  var formatter = DateFormat('dd/MM/yyyy HH:mm:ss.SSS');
  String formatted = formatter.format(dateTime);
  // prints the date in DD/MM/YYYY HH:MM:SS format
  return formatted;
}

DateTime julianToDateTime(double julianDate) {
  // The Julian date for the Unix epoch (1970-01-01 00:00:00 UTC) is 2440587.5
  double unixEpochJulianDate = 18294;

  // Calculate the number of seconds since the Unix epoch
  double secondsSinceEpoch = (julianDate - unixEpochJulianDate) * 24 * 60 * 60;

  // Create a DateTime object for the Unix epoch
  DateTime unixEpoch = DateTime.utc(1900, 1, 1);

  // Add the number of seconds since the Unix epoch to the DateTime object
  DateTime dateTime =
      unixEpoch.add(Duration(seconds: secondsSinceEpoch.toInt()));

  return dateTime;
}
