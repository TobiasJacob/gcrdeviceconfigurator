import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/channel_page.dart';
import 'package:gcrdeviceconfigurator/usb/usb_data.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/app_settings.dart';
import '../../i18n/languages.dart';

class ChannelItem extends ConsumerWidget {
  final int channelId;

  const ChannelItem({super.key, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[channelId];

    final usbStatus = ref.watch(usbProvider);
    final currentValues = usbStatus.maybeWhen(
      data: (data) => data.maybeMap(
        connected: (usbStatus) => usbStatus.currentValues,
        orElse: () => null,
      ),
      orElse: () => null,
    );
    final rawValue = currentValues?[channelId];
    final calibratedValue = currentValues != null
        ? parseValue(appSettings, currentValues, channelId)
        : null;

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = channelId;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChannelPage()));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownMenu<Usage>(
              dropdownMenuEntries: [
                for (var usage in Usage.values)
                  DropdownMenuEntry(
                    value: usage,
                    label: lang.usage(usage),
                  )
              ],
              onSelected: (Usage? value) async {
                if (value != null) {
                  appSettingsNotifier.update(appSettings.updateChannel(
                      channelId, channelSettings.updateChannelUsage(value)));
                  // Do not need to activate settings here because the usage does not change the behavior of the device
                  // await activateSettings(context, ref);
                  await appSettingsNotifier.save();
                }
              },
              initialSelection: channelSettings.usage,
            ),
            Text(
              lang.channel(channelId),
            ),
            SizedBox(
              width: 50,
              child: Text(
                calibratedValue != null
                    ? calibratedValue.toStringAsFixed(2)
                    : lang.error,
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                rawValue != null ? rawValue.toString() : lang.error,
              ),
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
          channelId: i,
        )
    ]);
  }
}
