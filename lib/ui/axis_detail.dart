import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

import '../data/data_point.dart';

class AxisDetail extends StatelessWidget {
  final ControllerAxis axis;
  final Function(int index, DataPoint newDataPoint) updateDataPoint;
  final Function(int index) createDataPoint;
  final Function(int index) deleteDataPoint;

  const AxisDetail(
      {super.key,
      required this.axis,
      required this.updateDataPoint,
      required this.createDataPoint,
      required this.deleteDataPoint});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
          child: Chart(
              updateDataPoint: updateDataPoint,
              dataPoints: axis.dataPoints,
              createDataPoint: createDataPoint,
              deleteDataPoint: deleteDataPoint)),
      Container(
        width: 200,
        color: Colors.amber,
      )
    ]);
  }
}
