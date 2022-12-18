import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/data/settings.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class Database extends ChangeNotifier {
  Map<String, Profile> profiles = {"Default": Profile.empty("Default")};

  String activeProfileId = "Default";
  String visibleProfileId = "Default";
  String visibleAxisId = "GasAxis";
  Settings settings = Settings.defaultSettings();

  final storage = LocalStorage('data.json');

  static Database of(context) {
    return Provider.of<Database>(context);
  }

  Future<void> load() async {
    await storage.ready;

    final jsonProfiles = storage.getItem("profiles");
    // Empty database
    if (jsonProfiles == null || jsonProfiles.isEmpty) {
      save();
      return;
    }

    profiles = {};
    for (final k in jsonProfiles.keys) {
      profiles[k] = Profile.fromJSON(jsonProfiles[k]);
    }

    final uiState = storage.getItem("uiState");
    if (uiState == null || uiState.isEmpty) {
      save();
      return;
    }
    activeProfileId = uiState["activeProfileId"] ?? "";
    // visibleProfileId = uiState["visibleProfileId"] ?? "";
    // visibleAxisId = uiState["visibleAxisId"] ?? "";
    makeValid();

    final settingsJSON = storage.getItem("settings") ?? {};
    if (settingsJSON == null || settingsJSON.isEmpty) {
      save();
      return;
    }
    settings = Settings.fromJSON(settingsJSON);
  }

  Future save() async {
    await storage.ready;
    var jsonProfiles = {};
    for (final k in profiles.keys) {
      jsonProfiles[k] = profiles[k]!.toJSON();
    }
    await storage.setItem("profiles", jsonProfiles);

    await storage.setItem("uiState", {
      activeProfileId: activeProfileId,
      visibleProfileId: visibleProfileId,
      visibleAxisId: visibleAxisId,
    });
    await storage.setItem("settings", settings.toJSON());

    notifyListeners();
  }

  void makeValid() {
    if (!profiles.containsKey(activeProfileId)) {
      activeProfileId = profiles.keys.first;
    }
    if (!profiles.containsKey(visibleProfileId)) {
      visibleProfileId = profiles.keys.first;
    }
    if (!profiles[activeProfileId]!.axes.containsKey(visibleAxisId)) {
      visibleAxisId = profiles[activeProfileId]!.axes.keys.first;
    }
  }
}
