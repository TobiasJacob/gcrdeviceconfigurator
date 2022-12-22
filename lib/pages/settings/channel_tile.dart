import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';

import '../../data/app_settings.dart';

class ChannelItem extends StatelessWidget {
  final int index;

  const ChannelItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettings.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$index:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 16),
        DropdownButton<Usage>(
          onChanged: (value) => appSettings.updateChannelUsage(index, value!),
          value: appSettings.channelSettings[index],
          items: Usage.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList(),
        )
      ],
    );
  }
}

class ChannelTile extends StatelessWidget {
  const ChannelTile({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettings.of(context);

    return SettingsTile(
        title: "Channel setup",
        child: Column(
          children: List<Widget>.generate(
              appSettings.channelSettings.length,
              (index) => ChannelItem(
                    index: index,
                  )),
        ));
  }
}
