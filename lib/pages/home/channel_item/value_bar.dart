import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/usb/usb_data.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ValueBar extends ConsumerWidget {
  final int channelId;

  const ValueBar({super.key, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);

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

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              calibratedValue != null
                  ? calibratedValue.toStringAsFixed(2)
                  : lang.nSlashA,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              rawValue != null ? rawValue.toString() : lang.nSlashA,
            ),
          ),
        ]);
  }
}
