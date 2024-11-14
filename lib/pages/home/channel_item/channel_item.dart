import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/value_bar.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/channel_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelItem extends ConsumerStatefulWidget {
  final int channelId;

  const ChannelItem({super.key, required this.channelId});

  @override
  ConsumerState<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends ConsumerState<ChannelItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[widget.channelId];

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = widget.channelId;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChannelPage()));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Text(
                (widget.channelId + 1).toString(),
              ),
            ),
            SizedBox(
              width: 200,
              child: DropdownMenu<ChannelUsage>(
                dropdownMenuEntries: [
                  for (var usage in ChannelUsage.values)
                    DropdownMenuEntry(
                      value: usage,
                      label: lang.channelUsage(usage),
                    )
                ],
                onSelected: (ChannelUsage? value) async {
                  if (value != null) {
                    appSettingsNotifier.update(appSettings.updateChannel(
                        widget.channelId, channelSettings.updateChannelUsage(value)));
                    await activateSettings(context, ref);
                    await appSettingsNotifier.save();
                  }
                },
                initialSelection: channelSettings.usage,
              ),
            ),
            SizedBox(
              width: 200,
              child: ValueBar(channelId: widget.channelId),
            ),
            SizedBox(
              width: 100,
              child: Text(
                channelSettings.minValue.toString(),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                channelSettings.maxValue.toString(),
              ),
            ),
            SizedBox(
              width: 100,
              child: Checkbox(
                  value: channelSettings.inverted,
                  onChanged: (value) async {
                    appSettingsNotifier.update(appSettings.updateChannel(
                        widget.channelId,
                        channelSettings.updateInverted(value ?? false)));
                    await activateSettings(context, ref);
                    await appSettingsNotifier.save();
                  }),
            ),
            SizedBox(
              width: 100,
              child: IconButton(
                icon: const Icon(Icons.restore),
                onPressed: () async {
                  appSettingsNotifier.update(
                      appSettings.updateChannel(widget.channelId, Channel.empty()));
                  await activateSettings(context, ref);
                  await appSettingsNotifier.save();
                },
              ),
            ),
            const SizedBox(
                width: 100,
                child: Icon(
                  Icons.arrow_right_rounded,
                ))
          ]),
    );
  }
}
