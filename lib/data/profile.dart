import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';

import 'app_settings.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum ProfileAxisType {
  gas,
  brake,
  clutch,
  handbrake,
}

@freezed
class Profile with _$Profile {
  const Profile._();
  
  @Assert('name.isNotEmpty')
  @Assert('axes.isNotEmpty')
  @Assert('axes.containsKey(ProfileAxisType.gas)')
  @Assert('axes.containsKey(ProfileAxisType.brake)')
  @Assert('axes.containsKey(ProfileAxisType.clutch)')
  @Assert('axes.containsKey(ProfileAxisType.handbrake)')
  factory Profile({
    required String name,
    required Map<ProfileAxisType, ProfileAxis> axes
  }) = _Profile;

  factory Profile.empty({String name = "Default"}) => Profile(name: name, axes: {
      ProfileAxisType.gas: ProfileAxis.empty(),
      ProfileAxisType.brake: ProfileAxis.empty(),
      ProfileAxisType.clutch: ProfileAxis.empty(),
      ProfileAxisType.handbrake: ProfileAxis.empty(),
    });

  factory Profile.fromJson(Map<String, Object?> json)
      => _$ProfileFromJson(json);

  Future<void> export(File file) async {
    await file.writeAsBytes(jsonEncode(toJson()).codeUnits);
  }

  Profile updateName(String name) {
    return copyWith(name: name);
  }
  
  Profile updateAxis(ProfileAxisType index, ProfileAxis updateChartDataPoint) {
    return copyWith(axes: {
      ...axes,
      index: updateChartDataPoint
    });
  }
}
