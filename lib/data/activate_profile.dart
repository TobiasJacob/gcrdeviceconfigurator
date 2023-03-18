import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'settings_provider.dart';
import '../dialogs/ok_dialog.dart';
import '../i18n/languages.dart';
import '../usb/config_serialize.dart';

Future<void> activateProfile(BuildContext context, WidgetRef ref) async {
  final lang = Languages.of(context);
  final usbStatus = ref.read(usbProvider);
  final profile = ref.read(profileProvider);
  usbStatus.maybeWhen(
    data: (data) async {
      data.maybeMap(
        connected: (usbConn) async {
          try {
            final config = serializeConfig(ref.read(settingsProvider), profile);
            await usbConn.device.sendSerializedConfig(config);
            showOkDialog(
                context, lang.info, lang.activatedProfile(profile.name));
            // ignore: empty_catches
          } catch (e) {
            showOkDialog(
                context, lang.error, lang.errorUploadProfile(e.toString()));
          }
        },
        orElse: () => showOkDialog(context, lang.error, lang.errorNotConnected),
      );
    },
    orElse: () => showOkDialog(context, lang.error, lang.errorNotConnected),
  );
}
