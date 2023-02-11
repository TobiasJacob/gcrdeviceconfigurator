import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home/profile_list.dart';
import 'home/update_device_button.dart';
import 'settings_page.dart';

enum ProfileAction { addEmptyProfile, importProfile }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(lang.appName),
          actions: <Widget>[
            const UpdateDeviceWidget(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
        floatingActionButton: Container(
          // Use primary color for floating action button
          decoration: ShapeDecoration(
              color: Theme.of(context).primaryColor,
              shape: const CircleBorder()),
          child: PopupMenuButton<ProfileAction>(
              icon: const Icon(Icons.add, color: Colors.white),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ProfileAction.addEmptyProfile,
                      child: Text(lang.addEmptyProfile),
                    ),
                    PopupMenuItem(
                      value: ProfileAction.importProfile,
                      child: Text(lang.importProfile),
                    ),
                  ],
              onSelected: (value) async {
                switch (value) {
                  case ProfileAction.addEmptyProfile:
                    final updateAndId = ref
                        .read(settingsProvider)
                        .createNewProfile(lang.newProfile);
                    ref
                        .read(settingsProvider.notifier)
                        .update(updateAndId.item1);
                    ref.read(profileIdProvier.notifier).state =
                        updateAndId.item2;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                    await ref.read(settingsProvider.notifier).save();
                    break;
                  case ProfileAction.importProfile:
                    FilePickerResult? inputFile = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        dialogTitle: lang.openFile,
                        allowedExtensions: ["json"],
                        type: FileType.custom);

                    if (inputFile == null) return;

                    for (var file in inputFile.files) {
                      try {
                        File returnedFile = File(file.path!);
                        Profile profile = await Profile.fromFile(returnedFile);
                        final updateAndId = ref
                            .read(settingsProvider)
                            .importProfile(profile);
                        ref.read(settingsProvider.notifier).update(updateAndId.item1);
                      } catch (e) {
                        await showOkDialog(context, lang.error, "Error importing profile ${file.path}: $e");
                      }
                    }
                    await ref.read(settingsProvider.notifier).save();
                    break;
                  default:
                }
              }),
        ),
        body: const ProfileList());
  }
}
