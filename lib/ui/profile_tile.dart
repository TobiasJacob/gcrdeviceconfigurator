import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../data/database.dart';
import '../data/profile.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final String profileKey;

  const ProfileTile(
      {super.key, required this.profile, required this.profileKey});

  @override
  Widget build(BuildContext context) {
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
            onSelected: (ev) {
              switch (ev) {
                case "Export":
                  exportProfile(context);
                  break;
                case "Delete":
                  showDeleteConfirmation(context);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Export', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
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
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Your File to desired location',
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
        final text = "File $outputFile exists. Overwrite?";

        AlertDialog alert = AlertDialog(
          title: const Text("Overwrite"),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );

        // show the dialog
        final confirmation = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );

        if (confirmation != true) {
          return;
        }
      }
      await returnedFile.writeAsBytes(jsonEncode(profile.toJSON()).codeUnits);
    } catch (e) {
      AlertDialog alert = AlertDialog(
        title: const Text("Error"),
        content: Text(e.toString()),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {},
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  Future<bool> showDeleteConfirmation(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to delete the profile?'),
            actions: [
              ElevatedButton(
                onPressed: () {},
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  database.deleteProfileIfMoreThanOne(profileKey);
                },
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
