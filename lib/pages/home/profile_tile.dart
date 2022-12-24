import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../data/database.dart';
import '../../data/profile.dart';
import '../../i18n/languages.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final String profileKey;

  const ProfileTile(
      {super.key, required this.profile, required this.profileKey});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final database = Database.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Radio<Profile>(
            value: profile,
            groupValue: database.activeProfile,
            onChanged: (value) {
              database.setActiveProfile(value!);
            },
          ),
          Expanded(
              child: Text(profile.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          PopupMenuButton<String>(
            onSelected: (ev) async {
              switch (ev) {
                case "Export":
                  exportProfile(context);
                  break;
                case "Delete":
                  deleteProfile(context);
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: profile, child: const ProfilePage())));
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

  Future<void> exportProfile(BuildContext context) async {
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

        if (confirmation == true) {
          await returnedFile
              .writeAsBytes(jsonEncode(profile.toJSON()).codeUnits);
        }
      }
    } catch (e) {
      await showOkDialog(context, lang.error, e.toString());
    }
  }

  void deleteProfile(BuildContext context) async {
    final lang = Languages.of(context);
    final database = Database.of(context, listen: false);
    final confimation = await showYesNoDialog(
      context,
      lang.deleteProfile,
      lang.wantToDeleteProfile,
    );
    if (confimation == true) {
      database.deleteProfileIfMoreThanOne(profileKey);
    }
  }
}
