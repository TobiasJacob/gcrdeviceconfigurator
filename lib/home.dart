import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/ui/axis_detail.dart';
import 'package:gcrdeviceconfigurator/ui/axis_list.dart';

import 'data/profile.dart';
import 'ui/profile_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer updateAxisValues;
  late Random random;

  Map<String, Profile> profiles = {
    "kdjeks": Profile("First Profile"),
    "dfse": Profile("Second Profile"),
    "skxi": Profile("Third Profile")
  };

  String activeProfileId = "kdjeks";
  String visibleProfileId = "kdjeks";
  String visibleAxisId = "GasAxis";

  @override
  void initState() {
    super.initState();
    random = Random();

    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        var newVal =
            profiles[activeProfileId]!.axes[visibleAxisId]!.currentValue +
                (random.nextDouble() - 0.5) * 0.03;

        newVal += (0.5 - newVal) * 0.002;
        profiles[activeProfileId]!.axes[visibleAxisId]!.currentValue =
            max(min(newVal, 1), 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentProfile = profiles[activeProfileId]!;
    var currentAxis = currentProfile.axes[visibleAxisId]!;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ProfileList(
              profiles: profiles,
              activeProfileId: activeProfileId,
              visibleProfileId: visibleProfileId,
              onChangeActiveProfile: (activeProfileId) {
                setState(() {
                  this.activeProfileId = activeProfileId ?? "";
                });
              },
              onChangeVisibleProfile: (visibleProfileId) {
                setState(() {
                  this.visibleProfileId = visibleProfileId ?? "";
                });
              },
              onUpdateProfiles: (profiles) {
                setState(() {
                  this.profiles = profiles;
                });
              }),
        ),
        const VerticalDivider(),
        Expanded(
            flex: 1,
            child: AxisList(
              axes: currentProfile.axes,
              visibleAxisId: visibleAxisId,
              onChangeVisibleAxis: (visibleAxisId) {
                setState(() {
                  this.visibleAxisId = visibleAxisId!;
                });
              },
            )),
        const VerticalDivider(),
        Expanded(
            flex: 3,
            child: AxisDetail(
                axis: currentAxis,
                updateAxis: (ControllerAxis axis) {
                  setState(() {
                    currentProfile.axes[visibleAxisId] = axis;
                  });
                })),
      ],
    );
  }
}
