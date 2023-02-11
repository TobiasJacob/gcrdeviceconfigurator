import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
// import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
// import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

import '../../data/profile.dart';
import '../../i18n/languages.dart';
import '../../usb/config_serialize.dart';
import '../profile_page.dart';

enum ProfileTileAction { duplicate, export, delete }

class ProfileTile extends ConsumerWidget {
  final String profileKey;

  const ProfileTile({super.key, required this.profileKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);

    final profile = ref.watch(settingsProvider.select((value) => value.profiles[profileKey] ?? Profile.empty()));
    final usbStatus = ref.watch(usbProvider);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Expanded(
              child: Text(profile.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          Tooltip(
            message: lang.uploadProfile,
            child: MaterialButton(
              onPressed: () {
                usbStatus.maybeWhen(
                  data: (data) async {
                    data.maybeMap(
                      connected: (usbConn) async {
                        try {
                          final config = serializeConfig(ref.read(settingsProvider), profile);
                          await usbConn.device.sendSerializedConfig(config);
                          showOkDialog(context, lang.info, lang.activatedProfile(profile.name));
                        // ignore: empty_catches
                        } catch (e) {
                          showOkDialog(context, lang.error, lang.errorUploadProfile(e.toString()));
                        }
                      },
                      orElse: () => showOkDialog(
                          context, lang.error, lang.errorNotConnected),
                    );
                  },
                  orElse: () =>
                      showOkDialog(context, lang.error, lang.errorNotConnected),
                );
                // usbData.value.map(connected: connected, disconnected: disconnected, uninitialized: uninitialized)
                // await usbStatus.device.sendSerializedConfig(serializeConfig(appSettings, database));
              },
              shape: const CircleBorder(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minWidth: 0,
              child: const Icon(
                Icons.play_circle,
              ),
            ),
          ),
          PopupMenuButton<ProfileTileAction>(
            onSelected: (ev) async {
              switch (ev) {
                case ProfileTileAction.duplicate:
                  final updateAndId = ref
                      .read(settingsProvider)
                      .importProfile(profile.copyWith());
                  ref.read(settingsProvider.notifier).update(updateAndId.item1);
                  ref.read(profileIdProvier.notifier).state =
                      updateAndId.item2;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  await ref.read(settingsProvider.notifier).save();
                  break;
                case ProfileTileAction.export:
                  exportProfile(context, ref);
                  break;
                case ProfileTileAction.delete:
                  deleteProfile(context, ref);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return ProfileTileAction.values.map((ProfileTileAction choice) {
                return PopupMenuItem<ProfileTileAction>(
                  value: choice,
                  child: Text(lang.axisTileOptions(choice)),
                );
              }).toList();
            },
          ),
          MaterialButton(
            onPressed: () {
              ref.read(profileIdProvier.notifier).state = profileKey;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            child: const Icon(
              Icons.arrow_right_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportProfile(BuildContext context, WidgetRef ref) async {
    final profile = ref
        .read(settingsProvider.select((value) => value.profiles[profileKey]!));

    final lang = Languages.of(context);
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: lang.saveFile,
        fileName: "${profile.name}.json",
        allowedExtensions: ["json"],
        type: FileType.custom);
    if (outputFile == null) return;

    try {
      if (!outputFile.endsWith(".json")) {
        outputFile += ".json";
      }
      File returnedFile = File(outputFile);
      if (await returnedFile.exists()) {
        final confirmation = await showYesNoDialog(
            context, lang.overwrite, lang.fileExistsOverwrite(outputFile));

        if (confirmation != true) {
          return;
        }
      }
      await profile.export(returnedFile);
    } catch (e) {
      await showOkDialog(context, lang.error, e.toString());
    }
  }

  void deleteProfile(BuildContext context, WidgetRef ref) async {
    final appSettings = ref.read(settingsProvider);
    final appSettingsNotifier = ref.read(settingsProvider.notifier);

    final lang = Languages.of(context);
    final confimation = await showYesNoDialog(
      context,
      lang.deleteProfile,
      lang.wantToDeleteProfile,
    );
    if (confimation == true) {
      appSettingsNotifier
          .update(appSettings.deleteProfileIfMoreThanOne(profileKey));
      await appSettingsNotifier.save();
    }
  }
}
