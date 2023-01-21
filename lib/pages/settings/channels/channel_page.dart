import 'package:dartusbhid/usb_device.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/app_settings.dart';
import '../../../i18n/languages.dart';

class ChannelPage extends ConsumerStatefulWidget {
  final int index;

  const ChannelPage({super.key, required this.index});

  @override
  ConsumerState<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends ConsumerState<ChannelPage> {
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();

  bool autoUpdate = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final appSettings = ref.watch(settingsProvider);
      final channel = appSettings.channelSettings[widget.index];

      minController.text = channel.minValue.toString();
      maxController.text = channel.maxValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final channel = ref.watch(channelProvider);
    final usbStatus = ref.watch(usbProvider); 
    final settingsNotifier = ref.watch(settingsProvider.notifier);

    final currentValue = usbStatus.maybeWhen(
      data: (data) => data.maybeMap(
        connected: (usbStatus) => usbStatus.currentValues[widget.index],
        orElse: () => 0,
      ),
      orElse: () => 0,
    );

    setMinValue(int value) {
      setState(() {
        settingsNotifier.updateChannel(channel.updateMinValue(value));
        minController.text = value.toString();
      });
    }

    setMaxValue(int value) {
      setState(() {
        settingsNotifier.updateChannel(channel.updateMaxValue(value));
        maxController.text = value.toString();
      });
    }

    setUsage(Usage usage) {
      settingsNotifier.updateChannel(channel.updateChannelUsage(usage));
    }

    if (autoUpdate) {
      if (currentValue < channel.minValue) {
        setMinValue(currentValue);
      }
      if (currentValue > channel.maxValue) {
        setMaxValue(currentValue);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.editChannel),
      ),
      body: Column(
        children: [
          SettingsTile(
              title: lang.usageLabel,
              child: DropdownButton<Usage>(
                onChanged: (value) {
                  try {
                    setUsage(value!);
                  } on AlreadyInUseException {
                    showOkDialog(
                        context, lang.error, lang.alreadyInUse(value!));
                  }
                },
                value: channel.usage,
                items: Usage.values
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(lang.usage(e))))
                    .toList(),
              )),
          SettingsTile(
              title: lang.minValue,
              child: FocusScope(
                onFocusChange: (value) {
                  final valueInt = int.tryParse(minController.text);
                  if (valueInt != null) {
                    setMinValue(valueInt);
                  }
                },
                child: TextField(
                  controller: minController,
                ),
              )),
          SettingsTile(
              title: lang.maxValue,
              child: FocusScope(
                onFocusChange: (value) {
                  final valueInt = int.tryParse(maxController.text);
                  if (valueInt != null) {
                    setMaxValue(valueInt);
                  }
                },
                child: TextField(
                  controller: maxController,
                ),
              )),
          SettingsTile(
            title: lang.currentValue,
            child: Column(
              children: [
                Text(currentValue.toString()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Auto calibration"),
                    Checkbox(
                        value: autoUpdate,
                        onChanged: (value) {
                          if (value == true) {
                            setMinValue(currentValue);
                            setMaxValue(currentValue);
                          }
                          setState(() {
                            autoUpdate = value!;
                          });
                        })
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
