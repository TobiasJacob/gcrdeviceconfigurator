import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:tuple/tuple.dart';

import 'channel.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';


String generateRandomString() {
  const len = 16;
  var r = Random.secure();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

@freezed
class AppSettings with _$AppSettings {
  const AppSettings._();
  
  @Assert('languageCode == "en" || languageCode == "de"')
  @Assert('channelSettings.length == 10')
  @Assert('profiles.isNotEmpty')
  factory AppSettings({
    required String languageCode,
    required String countryCode,
    required List<Channel> channelSettings,
    required Map<String, Profile> profiles
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, Object?> json)
      => _$AppSettingsFromJson(json);

  factory AppSettings.empty() => AppSettings(
    languageCode: "en",
    countryCode: "US",
    channelSettings: [
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
      Channel.empty(),
    ],
    profiles: {
      "defaultProfileId": Profile.empty()
    }
  );

  AppSettings updateLanguage(String languageCode, String countryCode) {
    return copyWith(
      languageCode: languageCode,
      countryCode: countryCode
    );
  }

  AppSettings updateUsage(int index, Usage usage) {
    if (usage != Usage.none) {
      for (var channel in channelSettings) {
        if (channel.usage == usage) {
          throw AlreadyInUseException();
        }
      }
    }
    return copyWith(
      channelSettings: List.of(channelSettings)
        ..[index] = channelSettings[index].copyWith(usage: usage)
    );
  }
  
  Tuple2<AppSettings, String> createNewProfile(String name) {
    // 100 tries to find a random key not in the Dict
    for (var i = 0; i < 100; i++) {
      final profileId = generateRandomString();
      if (profiles.containsKey(profileId)) {
        continue;
      }
      final profile = Profile.empty(name: name);
      return Tuple2(copyWith(
        profiles: Map.of(profiles)
          ..[profileId] = profile
      ), profileId);
    }
    throw Exception("Error creating profile. Consider deleting profiles.");
  }

  Tuple2<AppSettings, String> importProfile(Profile profile) {
    // 100 tries to find a random key not in the Dict
    for (var i = 0; i < 100; i++) {
      final profileId = generateRandomString();
      if (profiles.containsKey(profileId)) {
        continue;
      }
      return Tuple2(copyWith(
        profiles: Map.of(profiles)
          ..[profileId] = profile
      ), profileId);
    }
    throw Exception("Error creating profile. Consider deleting profiles.");
  }

  AppSettings updateProfile(String profileId, Profile profile) {
    return copyWith(
      profiles: Map.of(profiles)
        ..[profileId] = profile
    );
  }

  AppSettings deleteProfileIfMoreThanOne(String profileKey) {
    if (profiles.keys.length > 1) {
      return copyWith(
        profiles: Map.of(profiles)
          ..remove(profileKey)
      );
    }
    throw Exception("Error deleting profile. At least one profile must exist.");
  }

  AppSettings updateChannel(int index, Channel channel) {
    return copyWith(
      channelSettings: List.of(channelSettings)
        ..[index] = channel
    );
  }

  int numOfChannelsWithUsage(Usage usage) {
    return channelSettings.where((element) => element.usage == usage).length;
  }

  int channelWithUsage(Usage usage) {
    return channelSettings.indexWhere((element) => element.usage == usage);
  }
}

enum Usage { none, gas1, gas2, brake1, brake2, clutch, handbrake }

class AlreadyInUseException implements Exception {}

ProfileAxisType? getProfileAxisForUsage(Usage usage) {
  switch (usage) {
    case Usage.gas1:
    case Usage.gas2:
      return ProfileAxisType.gas;
    case Usage.brake1:
    case Usage.brake2:
      return ProfileAxisType.brake;
    case Usage.clutch:
      return ProfileAxisType.clutch;
    case Usage.handbrake:
      return ProfileAxisType.handbrake;
    default:
      return null;
  }
}