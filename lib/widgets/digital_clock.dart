import 'dart:async';

import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Stream<DateTime> timerStream;
  late StreamSubscription<DateTime> timerSubscription;

  @override
  void initState() {
    super.initState();
    timerStream = Stream<DateTime>.periodic(
        const Duration(seconds: 1), (x) => DateTime.now());
    timerSubscription = timerStream.listen((now) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final now = DateTime.now();
    return Row(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                  '${now.day < 10 ? "0${now.day}" : now.day}/${now.month < 10 ? "0${now.month}" : now.month}/${now.year}',
                  style: TextStyle(fontSize: size.height * 0.025)),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('${now.hour < 10 ? "0${now.hour}" : now.hour}',
                  style: TextStyle(fontSize: size.height * 0.025)),
            ),
            const SizedBox(width: 5),
            Text(":", style: TextStyle(fontSize: size.height * 0.025)),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('${now.minute < 10 ? "0${now.minute}" : now.minute}',
                  style: TextStyle(fontSize: size.height * 0.025)),
            ),
            const SizedBox(width: 5),
            Text(":", style: TextStyle(fontSize: size.height * 0.02)),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('${now.second < 10 ? "0${now.second}" : now.second}',
                  style: TextStyle(fontSize: size.height * 0.025)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    timerSubscription.cancel();
    super.dispose();
  }
}
