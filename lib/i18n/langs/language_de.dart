import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageDe extends Languages {
  @override
  String get appName => "Pedal Konfigurator";

  @override
  String get yes => "Ja";

  @override
  String get no => "Nein";

  @override
  String get error => "Fehler";

  @override
  String get ok => "Ok";

  @override
  String get newProfile => "Neues Profil";

  @override
  String axisTileOptions(String option) {
    switch (option) {
      case "Export":
        return "Exportieren";
      case "Delete":
        return "Löschen";
      default:
        return "Undefined";
    }
  }

  @override
  String get settings => "Einstellungen";

  @override
  String get english => "Englisch";

  @override
  String get german => "Deutsch";

  @override
  String get channelSettings => "Kanal";

  @override
  String get languageSettings => "Sprache";

  @override
  String usage(Usage usage) {
    switch (usage) {
      case Usage.gas:
        return "Gas";
      case Usage.brake:
        return "Bremse";
      case Usage.clutch:
        return "Kupplung";
      case Usage.handbrake:
        return "Handbremse";
      default:
        return "Unbenutzt";
    }
  }

  @override
  String get saveFile => "Datei speichern";

  @override
  String fileExistsOverwrite(String filename) {
    return "Die Datei $filename existiert bereits. Überschreiben?";
  }

  @override
  String get overwrite => "Überschreiben";

  @override
  String get deleteProfile => "Profil löschen";

  @override
  String get wantToDeleteProfile => "Möchten Sie das Profil löschen?";

  @override
  String editProfile(String profile) {
    return "Bearbeite $profile";
  }

  @override
  String get saveProfile => "Profil speichern";

  @override
  String get wantToSaveProfile => "Möchten Sie das Profil speichern?";
}
