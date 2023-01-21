import 'package:flutter/material.dart';

import '../../../data/data_point.dart';

class DragBall extends StatefulWidget {
  final DataPoint dataPoint;
  final Size size;
  final double margin;
  final Function(DataPoint) updateDataPoint;
  final Function() onPressed;

  const DragBall(
      {super.key,
      required this.dataPoint,
      required this.size,
      required this.margin,
      required this.updateDataPoint,
      required this.onPressed});

  @override
  State<DragBall> createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  Offset? dragStartLoc;
  DataPoint? dragStartDataPoint;

  @override
  Widget build(BuildContext context) {
    const ballDiameter = 24.0;
    final dataPoint = widget.dataPoint;
    final size = widget.size;
    final width = size.width - 2 * widget.margin;
    final height = size.height - 2 * widget.margin;
    final updateDataPoint = widget.updateDataPoint;

    return Positioned(
        left: dataPoint.x * width - ballDiameter / 2 + widget.margin,
        bottom: dataPoint.y * height - ballDiameter / 2 + widget.margin,
        child: GestureDetector(
          onTap: widget.onPressed,
          onPanStart: (details) {
            setState(() {
              dragStartLoc = details.globalPosition;
              dragStartDataPoint = dataPoint;
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            updateDataPoint(DataPoint(
                x: dragStartDataPoint!.x +
                    (details.globalPosition.dx - dragStartLoc!.dx) / width,
                y: dragStartDataPoint!.y -
                    (details.globalPosition.dy - dragStartLoc!.dy) / height));
          },
          child: const Material(
            elevation: 2,
            shape: CircleBorder(),
            color: Colors.blue,
            child: SizedBox(
              width: ballDiameter,
              height: ballDiameter,
            ),
          ),
        ));
  }
}
