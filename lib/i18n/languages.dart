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
  String axisTileOptions(String option);

  // Settings Page
  String get settings;
  String get english;
  String get german;
  String get languageSettings;
  String get channelSettings;

  // Usage
  String usage(Usage usage);

  // Main Page
  String get saveFile;
  String fileExistsOverwrite(String filename);
  String get overwrite;
  String get deleteProfile;
  String get wantToDeleteProfile;
}
