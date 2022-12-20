import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/data/settings.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

String generateRandomString() {
  const len = 16;
  var r = Random.secure();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

class Database extends ChangeNotifier {
  Map<String, Profile> profiles = {"Default": Profile.empty("Default")};

  late Profile activeProfile;
  Settings settings = Settings.defaultSettings();

  bool edited = false;
  Random random = Random();
  final storage = LocalStorage('data.json');

  Database() {
    activeProfile = profiles.values.first;
    profiles.values.first.addListener(onProfileChanged);
  }

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
      var profile = Profile.fromJSON(jsonProfiles[k]);
      profiles[k] = profile;
      profile.addListener(onProfileChanged);
    }

    final uiState = storage.getItem("uiState");
    if (uiState == null || uiState.isEmpty) {
      save();
      return;
    }
    // activeProfileId = uiState["activeProfileId"] ?? "";
    if (!profiles.containsValue(activeProfile)) {
      activeProfile = profiles.values.first;
    }

    final settingsJSON = storage.getItem("settings") ?? {};
    if (settingsJSON == null || settingsJSON.isEmpty) {
      save();
      return;
    }
    settings = Settings.fromJSON(settingsJSON);
    edited = false;
    notifyListeners();
  }

  Future save() async {
    await storage.ready;
    var jsonProfiles = {};
    for (final k in profiles.keys) {
      jsonProfiles[k] = profiles[k]!.toJSON();
    }
    await storage.setItem("profiles", jsonProfiles);
    // await storage.setItem("uiState", {"activeProfileId": activeProfileId});
    await storage.setItem("settings", settings.toJSON());
    edited = false;
    notifyListeners();
  }

  // Actions profiles
  void setActiveProfile(Profile profile) {
    assert(profiles.containsValue(profile));
    activeProfile = profile;
    edited = true;
    notifyListeners();
  }

  void createNewProfile() {
    // 100 tries to find a random key not in the Dict
    for (var i = 0; i < 100; i++) {
      final profileId = generateRandomString();
      if (profiles.containsKey(profileId)) {
        continue;
      }
      var profile = Profile.empty("New profile");
      profiles[profileId] = profile;
      profile.addListener(onProfileChanged);
      break;
    }
    edited = true;
    notifyListeners();
  }

  void deleteProfileIfMoreThanOne(Profile profile) {
    if (profiles.keys.length > 1) {
      profiles.remove(profile);
      notifyListeners();
    }
  }

  void onProfileChanged() {
    edited = true;
  }
}
