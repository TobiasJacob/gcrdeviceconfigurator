import 'package:dartusbhid/usb_device.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';
import 'package:provider/provider.dart';

import '../../../data/app_settings.dart';
import '../../../i18n/languages.dart';

class ChannelPage extends StatefulWidget {
  final int index;

  const ChannelPage({super.key, required this.index});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();

  bool autoUpdate = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      final channel = appSettings.channelSettings[widget.index];

      minController.text = channel.minValue.toString();
      maxController.text = channel.maxValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final appSettings = AppSettings.of(context);
    final channel = appSettings.channelSettings[widget.index];
    final usbStatus = USBStatus.of(context);
    final currentValue = usbStatus.currentValues[widget.index];

    if (autoUpdate) {
      if (currentValue < channel.minValue) {
        channel.setMinValue(currentValue);
        minController.text = channel.minValue.toString();
      }
      if (currentValue > channel.maxValue) {
        channel.setMaxValue(currentValue);
        maxController.text = channel.maxValue.toString();
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
                    appSettings.updateUsage(widget.index, value!);
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
                    channel.setMinValue(valueInt);
                  }
                  minController.text = channel.minValue.toString();
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
                    channel.setMaxValue(valueInt);
                  }
                  maxController.text = channel.maxValue.toString();
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
                            channel.setMinValue(currentValue);
                            minController.text = channel.minValue.toString();
                            channel.setMaxValue(currentValue);
                            maxController.text = channel.maxValue.toString();
                          }
                          autoUpdate = value ?? false;
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
