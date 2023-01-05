import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages)!;
  }

  String get appName;
  String get yes;
  String get no;
  String get error;
  String get ok;

  // Main Page
  String get newProfile;
  String axisTileOptions(String option);

  // Settings Page
  String get settings;
  String get english;
  String get german;
  String get languageSettings;
  String get channelSettings;

  // Usage
  String usage(Usage usage);

  // Profile tile
  String get saveFile;
  String fileExistsOverwrite(String filename);
  String get overwrite;
  String get deleteProfile;
  String get wantToDeleteProfile;

  // Profile Page
  String editProfile(String profile);
  String get saveProfile;
  String get wantToSaveProfile;

  // App Settings
  String get saveSettings;
  String get wantToSaveSettings;

  String channel(int index);
  String alreadyInUse(Usage usage);

  // Channel Settings
  String get editChannel;
  String get usageLabel;
  String get minValue;
  String get maxValue;
  String get currentValue;
}
