import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mtl;

class WMRow extends StatelessWidget {
  final String? mode;
  final String? station;
  final IconData? iconName;
  final mtl.Color color;
  const WMRow(
      {super.key, this.mode, this.station, this.iconName, required this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          width: size.width * 0.04,
          height: size.width * 0.05,
          child: Center(
            child: Text(
              station!,
              style: TextStyle(
                fontSize: size.width * 0.015,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: color),
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          width: size.width * .12,
          height: size.height * .05,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mode!,
                  style: TextStyle(
                    fontSize: size.height * .03,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  iconName!,
                  color: const Color(0xffffffff),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
