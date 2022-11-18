import 'package:flutter/material.dart';

import '../data/axis.dart';

class AxisTile extends StatelessWidget {
  final ControllerAxis axis;
  final String axisId;
  final String visibleAxisId;
  final Function(String?) onChangeVisibleAxis;

  const AxisTile(
      {super.key,
      required this.axis,
      required this.axisId,
      required this.visibleAxisId,
      required this.onChangeVisibleAxis});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: axisId == visibleAxisId ? Colors.blue[100] : null),
      child: Row(
        children: [
          Expanded(
              child: Text(axis.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {
              onChangeVisibleAxis(axisId);
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
