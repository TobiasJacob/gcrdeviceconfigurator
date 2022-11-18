import 'package:flutter/material.dart';

import '../data/data_point.dart';

class DragBall extends StatefulWidget {
  final DataPoint dataPoint;
  final Size size;
  final Function(DataPoint) updateDataPoint;

  const DragBall(
      {super.key,
      required this.dataPoint,
      required this.size,
      required this.updateDataPoint});

  @override
  State<DragBall> createState() => _DragBallState();
}

class _DragBallState extends State<DragBall> {
  Offset? dragStartLoc;
  DataPoint? dragStartDataPoint;

  @override
  Widget build(BuildContext context) {
    const ballDiameter = 24.0;
    var dataPoint = widget.dataPoint;
    var size = widget.size;
    var updateDataPoint = widget.updateDataPoint;
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return Positioned(
        left: dataPoint.x * size.width - ballDiameter / 2,
        bottom: dataPoint.y * size.height - ballDiameter / 2,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              dragStartLoc = details.globalPosition;
              dragStartDataPoint = dataPoint;
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            updateDataPoint(DataPoint(
                dragStartDataPoint!.x +
                    (details.globalPosition.dx - dragStartLoc!.dx) / size.width,
                dragStartDataPoint!.y -
                    (details.globalPosition.dy - dragStartLoc!.dy) /
                        size.height));
          },
          child: const Material(
            elevation: 12,
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
