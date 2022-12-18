import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/ui/axis_detail.dart';
import 'package:gcrdeviceconfigurator/ui/axis_list.dart';
import 'package:gcrdeviceconfigurator/ui/save_buttons.dart';

import 'data/database.dart';
import 'data/profile.dart';
import 'ui/profile_list.dart';

class Home extends StatefulWidget {
  final Database database;
  final Function updateLanguage;

  const Home({super.key, required this.database, required this.updateLanguage});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController profileNameController = TextEditingController();

  bool edited = false;

  @override
  void initState() {
    super.initState();

    final database = widget.database;
    profileNameController.text =
        database.profiles[database.visibleProfileId]!.name;
  }

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    final profiles = database.profiles;
    final activeProfileId = database.activeProfileId;
    final visibleProfileId = database.visibleProfileId;
    final visibleAxisId = database.visibleAxisId;

    // print(profiles.keys);
    // print(visibleAxisId);
    // print(visibleProfileId);
    var currentProfile = profiles[visibleProfileId]!;
    var currentAxis = currentProfile.axes[visibleAxisId]!;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: edited
              ? SaveOrResetButtons(
                  onSave: () async {
                    setState(() {
                      // loadFuture = database.save();
                      edited = false;
                    });
                  },
                  onDiscard: () async {
                    setState(() {
                      // loadFuture = database.load();
                      edited = false;
                    });
                  },
                )
              : ProfileList(
                  profiles: profiles,
                  activeProfileId: activeProfileId,
                  visibleProfileId: visibleProfileId,
                  onChangeActiveProfile: (activeProfileId) {
                    setState(() {
                      database.activeProfileId = activeProfileId;
                    });
                  },
                  onChangeVisibleProfile: (visibleProfileId) {
                    setState(() {
                      database.visibleProfileId = visibleProfileId;
                      profileNameController.text =
                          profiles[visibleProfileId]!.name;
                    });
                  },
                  onUpdateProfiles: (profiles) {
                    setState(() {
                      database.profiles = profiles;
                      database.makeValid();
                      database.save();
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
                  database.visibleAxisId = visibleAxisId!;
                });
              },
            )),
        const VerticalDivider(),
        Expanded(
          flex: 3,
          child: AxisDetail(
            axis: currentAxis,
            profile: currentProfile,
            profileNameController: profileNameController,
            updateAxis: (ControllerAxis axis) {
              setState(() {
                edited = true;
                currentProfile.axes[visibleAxisId] = axis;
              });
            },
            updateProfile: (profile) {
              setState(() {
                edited = true;
                profiles[visibleProfileId] = profile;
              });
            },
          ),
        ),
      ],
    );
  }
}
