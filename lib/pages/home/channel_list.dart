import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/button_item.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/channel_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelList extends ConsumerWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(settingsProvider);
    final lang = Languages.of(context);

    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Text(lang.usageLabel, textAlign: TextAlign.center,),
            ),
            SizedBox(
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(lang.currentValue),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(lang.rawValue),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(lang.minValue),
            ),
            SizedBox(
              width: 100,
              child: Text(lang.maxValue),
            ),
            SizedBox(width: 100, child: Text(lang.inverted)),
            SizedBox(width: 100, child: Text(lang.reset)),
            const SizedBox(width: 100)
          ]),
      for (var i = 0; i < appSettings.channelSettings.length; i++)
        ChannelItem(
          channelId: i,
        ),
      for (var i = 0; i < appSettings.buttonSettings.length; i++)
        ButtonItem(
          buttonId: i,
        ),
        
    ]);
  }
}
