import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/axis_tile.dart';

import '../data/axis.dart';
import '../data/database.dart';
import '../data/profile.dart';

class AxisList extends StatelessWidget {
  final Function(ControllerAxis axis) onSelect;

  const AxisList({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final profile = Profile.of(context);

    var axesKeys = profile.axes.keys.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: axesKeys.length,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(
            axis: profile.axes[axesKeys[index]]!, onSelect: onSelect);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
