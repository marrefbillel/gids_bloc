import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:gids_bloc/widgets/working_mode_row.dart';

class WorkingModeStream extends StatefulWidget {
  final StreamController<int> dataStreamController;
  final String? station;
  const WorkingModeStream(
      {super.key, required this.dataStreamController, this.station});

  @override
  State<WorkingModeStream> createState() => _WorkingModeStreamState();
}

class _WorkingModeStreamState extends State<WorkingModeStream> {
  String? _mode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: widget.dataStreamController.stream.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            String? newMode;
            switch (data) {
              case 145:
                newMode = 'TM';
                break;
              case 146:
                newMode = 'TM + RG';
                break;
              case 147:
                newMode = 'TM + TC';
                break;
            }
            //if (newMode != null && newMode != _mode) {
            if (newMode != null) {
              _mode = newMode;
              sink.add(_mode!);
            }
          },
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: (sink) {
          sink.addError('No data for 5 sec');
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final mode = snapshot.data;
          if (mode == null) {
            return const Text('Waiting for data...');
          } else {
            switch (mode) {
              case 'TM':
                return WMRow(
                  mode: 'TM',
                  station: widget.station!,
                  iconName: FluentIcons.double_chevron_down8,
                  color: const Color(0xFF009688),
                );
              case 'TM + TC':
                return WMRow(
                  mode: 'TM+TC',
                  station: widget.station!,
                  iconName: FluentIcons.double_chevron_up8,
                  color: const Color(0xFFDC143C),
                );
              case 'TM + RG':
                return WMRow(
                  mode: 'TM+RG',
                  station: widget.station!,
                  iconName: FluentIcons.communications,
                  color: const Color(0xFFFFC300),
                );
              default:
                return const Text('Waiting for data...');
            }
          }
        }
      },
    );
  }
}
