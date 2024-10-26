import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

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
  factory AppSettings({
    required String languageCode,
    required String countryCode,
    required List<Channel> channelSettings
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
    ]
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

enum Usage { none, gas, brake, clutch, handbrake, other }

class AlreadyInUseException implements Exception {}
