import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
// import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
// import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

import '../../i18n/languages.dart';
import '../profile_page.dart';

class ProfileTile extends ConsumerWidget {
  final String profileKey;

  const ProfileTile(
      {super.key, required this.profileKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);

    final profile = ref.watch(settingsProvider.select((value) => value.profiles[profileKey]!));

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
          PopupMenuButton<String>(
            onSelected: (ev) async {
              switch (ev) {
                case "Export":
                  exportProfile(context, ref);
                  break;
                case "Delete":
                  deleteProfile(context, ref);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Export', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(lang.axisTileOptions(choice)),
                );
              }).toList();
            },
          ),
          MaterialButton(
            onPressed: () {
              ref.read(visibleProfileProvider.notifier).setVisibleProfile(profileKey);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePage()));
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
    final profile = ref.read(settingsProvider.select((value) => value.profiles[profileKey]!));

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
      appSettingsNotifier.update(appSettings.deleteProfileIfMoreThanOne(profileKey));
      appSettingsNotifier.save();
    }
  }
}
