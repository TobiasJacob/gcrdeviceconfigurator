import 'package:dartusbhid/open_device.dart';
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
import '../../../usb/usb_data.dart';

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
        orElse: () => null,
      ),
      orElse: () => null,
    );

    updateValues(int? minValue, int? maxValue) {
      setState(() {
        Channel updatedChannel = channel;
        if (minValue != null && maxValue != null) { // Both values are set simultaneously so that the min value is always smaller than the max value
          updatedChannel = channel.updateMinMaxValue(minValue, maxValue);
          minController.text = minValue.toString();
          maxController.text = maxValue.toString();
        } else if (minValue != null) {
          updatedChannel = channel.updateMinValue(minValue);
          minController.text = currentValue.toString();
        } else if (maxValue != null) {
          updatedChannel = channel.updateMaxValue(maxValue);
          maxController.text = currentValue.toString();
        }
        if (updatedChannel != channel) {
          settingsNotifier.updateChannel(updatedChannel);
        }
      });
    }
  
    setUsage(Usage usage) {
      settingsNotifier.updateChannel(channel.updateChannelUsage(usage));
    }

    if (autoUpdate) {
      if (currentValue != null && currentValue < channel.minValue && currentValue > channel.maxValue) {
        Future(() {
          updateValues(currentValue, currentValue);
        });
      }
      if (currentValue != null && currentValue < channel.minValue) {
        Future(() {
          updateValues(currentValue, null);
        });
      }
      if (currentValue != null && currentValue > channel.maxValue) {
        Future(() {
          updateValues(null, currentValue);
        });
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
                    updateValues(valueInt, null);
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
                    updateValues(null, valueInt);
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
                            updateValues(((currentValue ?? 0) - 1).clamp(0, 4095), ((currentValue ?? 0) + 1).clamp(0, 4095));
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
