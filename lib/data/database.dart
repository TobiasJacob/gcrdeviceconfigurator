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
  late Profile visibleProfile;
  late ControllerAxis visibleAxis;
  Settings settings = Settings.defaultSettings();
  Random random = Random();

  final storage = LocalStorage('data.json');

  Database() {
    activeProfile = profiles.values.first;
    visibleProfile = profiles.values.first;
    visibleAxis = activeProfile.axes.values.first;
    makeValid();
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
      profiles[k] = Profile.fromJSON(jsonProfiles[k]);
    }

    final uiState = storage.getItem("uiState");
    if (uiState == null || uiState.isEmpty) {
      save();
      return;
    }
    // activeProfileId = uiState["activeProfileId"] ?? "";
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
    // await storage.setItem("uiState", {"activeProfileId": activeProfileId});
    await storage.setItem("settings", settings.toJSON());
  }

  void makeValid() {
    if (!profiles.containsValue(activeProfile)) {
      activeProfile = profiles.values.first;
    }

    if (!profiles.containsValue(visibleProfile)) {
      visibleProfile = profiles.values.first;
    }

    if (!visibleProfile.axes.containsValue(visibleAxis)) {
      visibleAxis = visibleProfile.axes.values.first;
    }
  }

  // Actions
  void updateCurrentAxisValue() {
    var newVal = visibleAxis.currentValue + (random.nextDouble() - 0.5) * 0.03;

    newVal += (0.5 - newVal) * 0.002;
    visibleAxis.currentValue = max(min(newVal, 1), 0);
    notifyListeners();
  }

  // Actions profiles
  void setActiveProfile(Profile profile) {
    assert(profiles.containsValue(profile));
    activeProfile = profile;
    notifyListeners();
  }

  void setVisibleProfile(Profile profile) {
    assert(profiles.containsValue(profile));
    visibleProfile = profile;
    notifyListeners();
  }

  void createNewProfile() {
    // 100 tries to find a random key not in the Dict
    for (var i = 0; i < 100; i++) {
      final profileId = generateRandomString();
      if (profiles.containsKey(profileId)) {
        continue;
      }
      profiles[profileId] = Profile.empty("New profile");
      visibleProfile = profiles[profileId]!;
      break;
    }
    notifyListeners();
  }

  void deleteProfileIfMoreThanOne() {
    if (profiles.keys.length > 1) {
      profiles.remove(visibleProfile);
      visibleProfile = profiles.values.first;
      notifyListeners();
    }
  }

  // Actions chart
  void updateChartDataPoint(int i, DataPoint point) {
    var x = point.x;
    var y = point.y;
    if (i > 0) {
      x = max(x, visibleAxis.dataPoints[i - 1].x);
    } else {
      x = max(x, 0);
    }
    if (i < visibleAxis.dataPoints.length - 1) {
      x = min(x, visibleAxis.dataPoints[i + 1].x);
    } else {
      x = min(x, 1);
    }
    y = max(y, 0);
    y = min(y, 1);
    visibleAxis.dataPoints[i] = DataPoint(x, y);
    notifyListeners();
  }

  void deleteChartDataPointIfMoreThanTwo(int i) {
    if (visibleAxis.dataPoints.length > 2) {
      visibleAxis.dataPoints.removeAt(i);
    }
    notifyListeners();
  }

  void addChartDataPointAfter(int i) {
    visibleAxis.dataPoints.insert(
        i + 1,
        DataPoint(
          (visibleAxis.dataPoints[i].x + visibleAxis.dataPoints[i + 1].x) / 2,
          (visibleAxis.dataPoints[i].y + visibleAxis.dataPoints[i + 1].y) / 2,
        ));
    notifyListeners();
  }

  // Actions axes
  void changeVisibleAxis(ControllerAxis axis) {
    assert(visibleProfile.axes.containsValue(axis));
    visibleAxis = axis;
    notifyListeners();
  }

  // Actions detail axis
  void updateProfileName(String profileName) {
    visibleProfile.name = profileName;
    notifyListeners();
  }

  void setAxisSmoothing(Smoothing? smoothing) {
    visibleAxis.smoothing = smoothing ?? Smoothing.normal;
    notifyListeners();
  }
}
