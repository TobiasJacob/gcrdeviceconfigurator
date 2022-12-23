import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages)!;
  }

  String get appName;

  // Settings
  String get settings;
  String get english;
  String get german;
  String get languageSettings;
  String get channelSettings;
}
