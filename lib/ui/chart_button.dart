import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

class ChartButton extends StatelessWidget {
  final DataPoint dataPoint;
  final Size size;
  final Function() onPressed;

  const ChartButton(
      {Key? key,
      required this.dataPoint,
      required this.size,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 50.0;
    const buttonHeight = 25.0;
    return Positioned(
      left: dataPoint.x * size.width - buttonWidth / 2,
      bottom: dataPoint.y * size.height - buttonHeight / 2,
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(onPressed: onPressed, child: const Text("+")),
    );
  }
}
