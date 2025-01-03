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
  String get info;

  // Main Page
  String get newProfile;
  // String axisTileOptions(ProfileTileAction option);
  String get addEmptyProfile;
  String get importProfile;
  String get openFile;

  // Settings Page
  String get settings;
  String get english;
  String get german;
  String get languageSettings;
  String get channelSettings;

  // Usage
  String channelUsage(ChannelUsage usage);
  String buttonUsage(ButtonUsage usage);

  // Profile tile
  String get saveFile;
  String fileExistsOverwrite(String filename);
  String get overwrite;
  String get deleteProfile;
  String get wantToDeleteProfile;
  String get uploadProfile;
  String errorUploadProfile(String msg);
  String get errorNotConnected;
  String get nSlashA;
  String get on;
  String get off;

  // Profile Page
  String editProfile(String profile);
  String get saveProfile;
  String get wantToSaveProfile;

  // App Settings
  String get saveSettings;
  String get wantToSaveSettings;

  String channel(int index);
  String alreadyInUse(ChannelUsage usage);

  // Channel Settings
  String get editChannel;
  String get usageLabel;
  String get minValue;
  String get maxValue;
  String get currentValue;
  String get rawValue;
  String get inverted;
  String get reset;
  String get index;

  // Profile Axis
  String preset(int index);
}
