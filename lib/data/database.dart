import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

String generateRandomString() {
  const len = 16;
  var r = Random.secure();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

class Database extends ChangeNotifier {
  late Profile activeProfile;

  Map<String, Profile> profiles = {"Default": Profile.empty("Default")};

  bool edited = false;
  final storage = LocalStorage('data.json');

  Database() {
    activeProfile = profiles.values.first;
  }

  static Database of(context, {bool listen = true}) {
    return Provider.of<Database>(context, listen: listen);
  }

  Future<void> load() async {
    await storage.ready;

    final jsonProfiles = storage.getItem("profiles");
    // Empty database
    if (jsonProfiles == null || jsonProfiles.isEmpty) {
      return;
    }

    profiles = {};
    for (final k in jsonProfiles.keys) {
      var profile = Profile.fromJSON(jsonProfiles[k]);
      profiles[k] = profile;
    }

    final activeProfileId = storage.getItem("activeProfileId");
    if (activeProfileId is String && profiles.containsKey(activeProfileId)) {
      activeProfile = profiles[activeProfileId]!;
    } else {
      activeProfile = profiles.values.first;
    }

    resetEdited();
    notifyListeners();
  }

  Future save() async {
    await storage.ready;
    var jsonProfiles = {};
    for (final k in profiles.keys) {
      jsonProfiles[k] = profiles[k]!.toJSON();
    }
    await storage.setItem("profiles", jsonProfiles);
    for (var k in profiles.keys) {
      if (profiles[k] == activeProfile) {
        await storage.setItem("activeProfileId", k);
      }
    }
    resetEdited();
    notifyListeners();
  }

  // Actions profiles
  void setActiveProfile(Profile profile) {
    assert(profiles.containsValue(profile));
    activeProfile = profile;
    edited = true;
    notifyListeners();
  }

  Profile createNewProfile() {
    // 100 tries to find a random key not in the Dict
    for (var i = 0; i < 100; i++) {
      final profileId = generateRandomString();
      if (profiles.containsKey(profileId)) {
        continue;
      }
      var profile = Profile.empty("New profile");
      profiles[profileId] = profile;
      edited = true;
      notifyListeners();
      return profile;
    }
    throw Exception("Error creating profile. Consider deleting profiles.");
  }

  void deleteProfileIfMoreThanOne(String profileKey) {
    if (profiles.keys.length > 1) {
      profiles.remove(profileKey);
      save();
      notifyListeners();
    }
  }

  bool thisOrDependencyEdited() {
    if (edited) {
      return true;
    }
    for (final profile in profiles.values) {
      if (profile.thisOrDependencyEdited()) {
        return true;
      }
    }
    return false;
  }

  void resetEdited() {
    for (final profile in profiles.values) {
      profile.resetEdited();
    }
    edited = false;
  }
}
