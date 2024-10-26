import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/channel_page.dart';
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
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[index];

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = index;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChannelPage()));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${lang.channel(index)}: ${lang.usage(channelSettings.usage)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            DropdownMenu<Usage>(
              dropdownMenuEntries: [
                for (var usage in Usage.values)
                  DropdownMenuEntry(
                    value: usage,
                    label: lang.usage(usage),
                  )
              ],
              onSelected: (Usage? value) {
                if (value != null) {
                  appSettingsNotifier.update(
                      appSettings.updateChannel(index, channelSettings.updateChannelUsage(value))
                  );
                }
              },
              initialSelection: channelSettings.usage,
            ),
            const Icon(
              Icons.arrow_right_rounded,
            )
          ]),
    );
  }
}

class ChannelList extends ConsumerWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(settingsProvider);

    return Column(children: [
      for (var i = 0; i < appSettings.channelSettings.length; i++)
        ChannelItem(
          index: i,
        )
    ]);
  }
}
