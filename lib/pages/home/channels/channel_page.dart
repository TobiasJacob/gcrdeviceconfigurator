import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/chart/chart.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/app_settings.dart';
import '../../../i18n/languages.dart';

class ChannelPage extends ConsumerStatefulWidget {
  const ChannelPage({super.key});

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

    setState(() {
      final appSettings = ref.read(settingsProvider);
      final channel = ref.read(channelProvider);

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
        connected: (usbStatus) =>
            usbStatus.currentValues[ref.read(channelIdProvider)],
        orElse: () => null,
      ),
      orElse: () => null,
    );

    updateValues(int? minValue, int? maxValue) {
      setState(() {
        var updatedChannel = channel;
        if (minValue != null && maxValue != null) {
          // Both values are set simultaneously so that the min value is always smaller than the max value
          updatedChannel = channel.updateMinMaxValue(minValue, maxValue);
          minController.text = minValue.toString();
          maxController.text = maxValue.toString();
        } else if (minValue != null) {
          updatedChannel = channel.updateMinValue(minValue);
          minController.text = minValue.toString();
        } else if (maxValue != null) {
          updatedChannel = channel.updateMaxValue(maxValue);
          maxController.text = maxValue.toString();
        }
        if (updatedChannel != channel) {
          settingsNotifier.updateChannel(updatedChannel);
        }
      });
    }

    if (autoUpdate) {
      if (currentValue != null &&
          currentValue < channel.minValue &&
          currentValue > channel.maxValue) {
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

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final navigator = Navigator.of(context);
          bool value = await willPop(context);
          if (value) {
            navigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(lang.editChannel),
          ),
          body: Column(
            children: [
              Column(
                children: [
                  SettingsTile(
                      title: lang.minValue,
                      child: FocusScope(
                        onFocusChange: (value) {
                          if (value) {
                            return;
                          }
                          try {
                            final valueInt = int.parse(minController.text);
                            updateValues(valueInt, null);
                          } catch (e) {
                            showOkDialog(context, lang.error, "$e");
                            updateValues(channel.minValue, null);
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
                          if (value) {
                            return;
                          }
                          try {
                            final valueInt = int.parse(maxController.text);
                            updateValues(null, valueInt);
                          } catch (e) {
                            showOkDialog(context, lang.error, "$e");
                            updateValues(null, channel.maxValue);
                          }
                        },
                        child: TextField(
                          controller: maxController,
                        ),
                      )),
                  SettingsTile(
                      title: lang.inverted,
                      child: Checkbox(
                          value: channel.inverted,
                          onChanged: (value) {
                            updateValues(null, null);
                            settingsNotifier.updateChannel(
                                channel.updateInverted(value ?? false));
                          })),
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
                                    updateValues(
                                        ((currentValue ?? 0) - 1)
                                            .clamp(0, 4095),
                                        ((currentValue ?? 0) + 1)
                                            .clamp(0, 4095));
                                  }
                                  setState(() {
                                    autoUpdate = value!;
                                  });
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const VerticalDivider(),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(flex: 1, child: Chart()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < 6; i++)
                          ElevatedButton(
                              onPressed: () {
                                settingsNotifier.updateChannel(channel
                                    .updateProfileAxis(ProfileAxis.preset(i)));
                              },
                              child: Text("$i"))
                      ],
                    ),
                    const SizedBox(
                      width: 20
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> willPop(BuildContext context) async {
    final notif = ref.read(settingsProvider.notifier);
    activateSettings(context, ref);
    notif.save();
    return true;
  }
}
