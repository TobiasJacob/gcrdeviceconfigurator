import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageEn extends Languages {
  @override
  String get appName => "Pedal Configurator";

  @override
  String get yes => "Yes";

  @override
  String get no => "No";

  @override
  String get error => "Error";

  @override
  String get ok => "Ok";

  @override
  String get newProfile => "New Profile";

  @override
  String axisTileOptions(String option) {
    switch (option) {
      case "Export":
        return "Export";
      case "Delete":
        return "Delete";
      default:
        return "Undefined";
    }
  }

  @override
  String get settings => "Settings";

  @override
  String get english => "English";

  @override
  String get german => "German";

  @override
  String get channelSettings => "Channels";

  @override
  String get languageSettings => "Language";

  @override
  String usage(Usage usage) {
    switch (usage) {
      case Usage.gas:
        return "Gas";
      case Usage.brake:
        return "Brake";
      case Usage.clutch:
        return "Clutch";
      case Usage.handbrake:
        return "Handbrake";
      default:
        return "Not used";
    }
  }

  @override
  String get saveFile => "Save File";

  @override
  String fileExistsOverwrite(String filename) {
    return "File $filename exists. Overwrite?";
  }

  @override
  String get overwrite => "Overwrite";

  @override
  String get deleteProfile => "Delete Profile";

  @override
  String get wantToDeleteProfile => "Do you want to delete the profile?";

  @override
  String get uploadProfile => "Activate Profile";

  @override
  String errorUploadProfile(String msg) {
    return "Error activating profile: $msg";
  }

  @override
  String activatedProfile(String name) {
    return "Activated profile $name";
  }

  @override
  String get errorNotConnected => "Not connected to device";

  @override
  String editProfile(String profile) {
    return "Edit $profile";
  }

  @override
  String get saveProfile => "Save profile";

  @override
  String get wantToSaveProfile => "Do you want to save the profile?";

  @override
  String get saveSettings => "Save settings";

  @override
  String get wantToSaveSettings => "Do you want to save the settings?";

  @override
  String channel(int index) {
    return "Channel $index";
  }

  @override
  String alreadyInUse(Usage usage) {
    return "There already exists another channel for ${this.usage(usage)}";
  }

  @override
  String get editChannel => "Edit channel";

  @override
  String get usageLabel => "Usage";

  @override
  String get minValue => "Minimum";

  @override
  String get maxValue => "Maximum";

  @override
  String get currentValue => "Current Value";
}
