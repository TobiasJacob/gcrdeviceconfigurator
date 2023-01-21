import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis_view_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AxisTile extends ConsumerWidget {
  final Usage usage;
  final Function(Usage usage) onSelect;

  const AxisTile({super.key, required this.usage, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final visibleAxis = ref.watch(axisIdProvider);

    final backgroundColor = usage == visibleAxis ? Colors.blue[100] : null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: backgroundColor),
      child: Row(
        children: [
          Expanded(
              child: Text(lang.usage(usage),
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {
              onSelect(usage);
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
