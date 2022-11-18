import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/axis_tile.dart';

import '../data/axis.dart';

class AxisList extends StatelessWidget {
  final Map<String, ControllerAxis> axes;
  final String visibleAxisId;
  final Function(String?) onChangeVisibleAxis;

  const AxisList(
      {super.key,
      required this.axes,
      required this.visibleAxisId,
      required this.onChangeVisibleAxis});

  @override
  Widget build(BuildContext context) {
    var axesKeys = axes.keys.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: axes.length,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(
          axis: axes[axesKeys[index]]!,
          axisId: axesKeys[index],
          visibleAxisId: visibleAxisId,
          onChangeVisibleAxis: onChangeVisibleAxis,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
