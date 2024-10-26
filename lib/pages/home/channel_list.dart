import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/channel_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelList extends ConsumerWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(settingsProvider);

    return Column(children: [
      for (var i = 0; i < appSettings.channelSettings.length; i++)
        ChannelItem(
          channelId: i,
        )
    ]);
  }
}
