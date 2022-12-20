import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/axis_tile.dart';

import '../data/axis.dart';
import '../data/database.dart';

class AxisList extends StatelessWidget {
  const AxisList({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    var axesKeys = database.visibleProfile.axes.keys.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: axesKeys.length,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(
          axis: database.visibleProfile.axes[axesKeys[index]]!,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
