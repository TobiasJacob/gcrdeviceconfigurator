import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

class ChartButton extends StatelessWidget {
  final DataPoint dataPoint;
  final Size size;
  final String text;
  final Function() onPressed;
  final Offset? offset;

  const ChartButton(
      {Key? key,
      required this.dataPoint,
      required this.size,
      required this.text,
      required this.onPressed,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 48.0;
    const buttonHeight = 24.0;
    return Positioned(
      left: dataPoint.x * size.width - buttonWidth / 2 + (offset?.dx ?? 0),
      bottom: dataPoint.y * size.height - buttonHeight / 2 + (offset?.dy ?? 0),
      width: buttonWidth,
      height: buttonHeight,
      child: MaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        color: Colors.blue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: Text(text),
      ),
    );
  }
}
