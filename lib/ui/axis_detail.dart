import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

import '../data/data_point.dart';

class AxisDetail extends StatelessWidget {
  final ControllerAxis axis;
  final Function(String index, DataPoint newDataPoint) updateDataPoint;

  const AxisDetail(
      {super.key, required this.axis, required this.updateDataPoint});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: Chart(
        updateDataPoint: updateDataPoint,
        dataPoints: axis.dataPoints,
      )),
      Container(
        width: 200,
        color: Colors.amber,
      )
    ]);
  }
}
