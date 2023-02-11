import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';

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
  String get info => "Info";

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
  String get addEmptyProfile => "Leeres Profil hinzufügen";

  @override
  String get importProfile => "Profil importieren";

  @override
  String get openFile => "Datei öffnen";

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
      case Usage.gas1:
        return "Gas 1";
      case Usage.gas2:
        return "Gas 2";
      case Usage.brake1:
        return "Bremse 1";
      case Usage.brake2:
        return "Bremse 1";
      case Usage.clutch:
        return "Kupplung";
      case Usage.handbrake:
        return "Handbremse";
      default:
        return "Unbenutzt";
    }
  }

  @override
  String profileAxisType(ProfileAxisType usage) {
    switch (usage) {
      case ProfileAxisType.gas:
        return "Gas";
      case ProfileAxisType.brake:
        return "Bremse";
      case ProfileAxisType.clutch:
        return "Kupplung";
      case ProfileAxisType.handbrake:
        return "Handbremse";
      default:
        return "Not used";
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
  String get uploadProfile => "Profil aktivieren";

  @override
  String errorUploadProfile(String msg) {
    return "Fehler beim Aktivieren des Profils: $msg";
  }

  @override
  String activatedProfile(String name) {
    return "Profil $name aktiviert";
  }

  @override
  String get errorNotConnected => "Gerät nicht verbunden";

  @override
  String editProfile(String profile) {
    return "Bearbeite $profile";
  }

  @override
  String get saveProfile => "Profil speichern";

  @override
  String get wantToSaveProfile => "Möchten Sie das Profil speichern?";

  @override
  String get saveSettings => "Einstellungen speichern";

  @override
  String get wantToSaveSettings => "Möchten Sie die Einstellungen speichern?";

  @override
  String channel(int index) {
    return "Kanal $index";
  }

  @override
  String alreadyInUse(Usage usage) {
    return "Die Funktion ${this.usage(usage)} ist schon für einen anderen Kanal eingestellt.";
  }

  @override
  String get editChannel => "Kanal bearbeiten";

  @override
  String get usageLabel => "Funktion";

  @override
  String get minValue => "Minimum";

  @override
  String get maxValue => "Maximum";

  @override
  String get currentValue => "Aktueller Wert";
}
