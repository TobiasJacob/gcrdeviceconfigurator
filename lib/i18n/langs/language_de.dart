import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageDe extends Languages {
  @override
  String get appName => "Pedal Konfigurator";

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
}
