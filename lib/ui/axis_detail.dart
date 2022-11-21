import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

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
            onChanged: (value) {
              axis.smoothing = value ?? Smoothing.normal;
              updateAxis(axis);
            },
            value: axis.smoothing,
            items: const [
              DropdownMenuItem(
                value: Smoothing.highAccuracy,
                child: Text("Genauer"),
              ),
              DropdownMenuItem(
                value: Smoothing.normal,
                child: Text("Ausgewogen"),
              ),
              DropdownMenuItem(
                value: Smoothing.highSpeed,
                child: Text("Schneller"),
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
