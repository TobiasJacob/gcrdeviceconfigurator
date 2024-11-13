import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/button.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/value_bar.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/channel_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ButtonItem extends ConsumerWidget {
  final int buttonId;

  const ButtonItem({super.key, required this.buttonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final buttonSettings = appSettings.buttonSettings[buttonId];

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = buttonId;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChannelPage()));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: DropdownMenu<ButtonUsage>(
                dropdownMenuEntries: [
                  for (var usage in ButtonUsage.values)
                    DropdownMenuEntry(
                      value: usage,
                      label: lang.buttonUsage(usage),
                    )
                ],
                onSelected: (ButtonUsage? value) async {
                  if (value != null) {
                    appSettingsNotifier.update(appSettings.updateButton(
                        buttonId, buttonSettings.updateButtonUsage(value)));
                    await activateSettings(context, ref);
                    await appSettingsNotifier.save();
                  }
                },
                initialSelection: buttonSettings.usage,
              ),
            ),
            SizedBox(
              width: 200,
              child: ValueBar(channelId: buttonId),
            ),
            SizedBox(
              width: 100,
              child: Text(
                buttonSettings.upperThreshold.toString(),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                buttonSettings.lowerThreshold.toString(),
              ),
            ),
            SizedBox(
              width: 100,
              child: Checkbox(
                  value: buttonSettings.inverted,
                  onChanged: (value) async {
                    appSettingsNotifier.update(appSettings.updateButton(
                        buttonId,
                        buttonSettings.updateInverted(value ?? false)));
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
                      appSettings.updateButton(buttonId, Button.empty()));
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
