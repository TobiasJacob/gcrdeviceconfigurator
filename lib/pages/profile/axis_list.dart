import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/pages/profile/axis_tile.dart';

class AxisList extends StatelessWidget {
  final Function(ProfileAxisType usage) onSelect;

  const AxisList({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ProfileAxisType.values.length,
      itemBuilder: (BuildContext context, int index) {
        return AxisTile(usage: ProfileAxisType.values[index], onSelect: onSelect);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
