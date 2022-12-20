import 'package:flutter/material.dart';

import '../data/axis.dart';
import '../data/database.dart';

class AxisTile extends StatelessWidget {
  final ControllerAxis axis;

  const AxisTile({super.key, required this.axis});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    final backgroundColor =
        axis == database.visibleAxis ? Colors.blue[100] : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: backgroundColor),
      child: Row(
        children: [
          Expanded(
              child: Text(axis.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {
              database.changeVisibleAxis(axis);
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
