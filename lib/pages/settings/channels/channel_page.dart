import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';

import '../../../data/app_settings.dart';
import '../../../i18n/languages.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();

  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final channel = Channel.of(context);
    if (!initialized) {
      initialized = true;
      minController.text = channel.minValue.toString();
      maxController.text = channel.maxValue.toString();
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
                onChanged: (value) => channel.setUsage(value!),
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
        ],
      ),
    );
  }
}
