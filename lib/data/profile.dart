import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';

import 'app_settings.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const Profile._();
  
  @Assert('name.isNotEmpty')
  @Assert('axes.isNotEmpty')
  @Assert('!axes.containsKey(Usage.none)')
  @Assert('axes.containsKey(Usage.gas)')
  @Assert('axes.containsKey(Usage.brake)')
  @Assert('axes.containsKey(Usage.clutch)')
  @Assert('axes.containsKey(Usage.handbrake)')
  factory Profile({
    required String name,
    required Map<Usage, ProfileAxis> axes
  }) = _Profile;

  factory Profile.empty({String name = "Default"}) => Profile(name: name, axes: {
      Usage.gas: ProfileAxis.empty(),
      Usage.brake: ProfileAxis.empty(),
      Usage.clutch: ProfileAxis.empty(),
      Usage.handbrake: ProfileAxis.empty(),
    });

  factory Profile.fromJson(Map<String, Object?> json)
      => _$ProfileFromJson(json);

  Profile updateName(String name) {
    return copyWith(name: name);
  }
  
  Future export(File file) async {
    await file.writeAsBytes(jsonEncode(toJson()).codeUnits);
  }
}
