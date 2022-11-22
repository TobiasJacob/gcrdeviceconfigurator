import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:localstorage/localstorage.dart';

class Database {
  Map<String, Profile> profiles = {"Default": Profile.empty("Default")};

  String activeProfileId = "Default";
  String visibleProfileId = "Default";
  String visibleAxisId = "GasAxis";
  final storage = LocalStorage('data.json');

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

    activeProfileId = uiState["activeProfileId"] ?? "";
    // visibleProfileId = uiState["visibleProfileId"] ?? "";
    // visibleAxisId = uiState["visibleAxisId"] ?? "";
    makeValid();
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
