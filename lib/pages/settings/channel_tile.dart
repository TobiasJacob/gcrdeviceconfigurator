import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/settings/channels/channel_page.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';

import '../../data/app_settings.dart';
import '../../i18n/languages.dart';

class ChannelItem extends StatelessWidget {
  final int index;

  const ChannelItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChannelPage(
                      index: index,
                    )));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lang.channel(index),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Icon(
              Icons.arrow_right_rounded,
            )
          ]),
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
