import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/axis_tile.dart';

import '../data/axis.dart';
import '../data/profile.dart';

class AxisList extends StatelessWidget {
  final Function(ControllerAxis axis) onSelect;

  const AxisList({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final profile = Profile.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: profile.axes.length,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(axis: profile.axes[index], onSelect: onSelect);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
