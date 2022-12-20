import 'package:flutter/material.dart';

import '../data/axis.dart';

class AxisTile extends StatelessWidget {
  final int index;
  final ControllerAxis axis;
  final Function(ControllerAxis axis) onSelect;

  const AxisTile(
      {super.key,
      required this.index,
      required this.axis,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final visibleAxis = ControllerAxis.of(context);

    final backgroundColor = axis == visibleAxis ? Colors.blue[100] : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: backgroundColor),
      child: Row(
        children: [
          Expanded(
              child: Text("${index}: ${axis.usage.name}",
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {
              onSelect(axis);
            },
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            child: const Icon(
              Icons.arrow_right_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
