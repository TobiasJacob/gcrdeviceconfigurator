import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/settings/channels/channel_page.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/app_settings.dart';
import '../../i18n/languages.dart';

class ChannelItem extends ConsumerWidget {
  final int index;

  const ChannelItem({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = index;

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
              '${lang.channel(index)}: ${lang.usage(appSettings.channelSettings[index].usage)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Icon(
              Icons.arrow_right_rounded,
            )
          ]),
    );
  }
}

class ChannelTile extends ConsumerWidget {
  const ChannelTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);

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
