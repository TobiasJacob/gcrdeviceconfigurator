import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';

import '../../data/app_settings.dart';
import '../../i18n/languages.dart';

class ChannelItem extends StatelessWidget {
  final int index;

  const ChannelItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
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
              .map(
                  (e) => DropdownMenuItem(value: e, child: Text(lang.usage(e))))
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
    final lang = Languages.of(context);
    final appSettings = AppSettings.of(context);

    return SettingsTile(
        title: lang.channelSettings,
        child: Column(children: [
          for (var i = 0; i < appSettings.channelSettings.length; i++)
            ChannelItem(
              index: i,
            )
        ]));
  }
}
