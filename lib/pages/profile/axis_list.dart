import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/pages/profile/axis_tile.dart';

import '../../data/app_settings.dart';

class AxisList extends StatelessWidget {
  final Function(Usage usage) onSelect;

  const AxisList({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: Usage.values.length - 1,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(usage: Usage.values[index + 1], onSelect: onSelect);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
