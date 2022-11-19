import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

import '../data/data_point.dart';

class AxisDetail extends StatelessWidget {
  final ControllerAxis axis;
  final Function(ControllerAxis axis) updateAxis;

  const AxisDetail({super.key, required this.axis, required this.updateAxis});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: 200,
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButton(
            onChanged: (value) {},
            value: 0,
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text("Starke Glättung"),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text("Mittlere Glättung"),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text("Schwache Glättung"),
              )
            ],
          )
        ]),
      ),
      Expanded(
        child: Chart(
          axis: axis,
          updateAxis: updateAxis,
        ),
      )
    ]);
  }
}
