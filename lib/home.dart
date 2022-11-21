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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer updateAxisValues;
  late Random random;
  late Future loadFuture;
  final TextEditingController profileNameController = TextEditingController();

  late Database database;

  bool edited = false;

  @override
  void initState() {
    super.initState();
    random = Random();
    database = Database();
    loadFuture = database.load();

    profileNameController.text =
        database.profiles[database.visibleProfileId]!.name;

    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        var newVal = (database.profiles[database.visibleProfileId]
                    ?.axes[database.visibleAxisId]?.currentValue ??
                0.5) +
            (random.nextDouble() - 0.5) * 0.03;

        newVal += (0.5 - newVal) * 0.002;
        database
            .profiles[database.visibleProfileId]
            ?.axes[database.visibleAxisId]
            ?.currentValue = max(min(newVal, 1), 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
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
                            loadFuture = database.save();
                            edited = false;
                          });
                        },
                        onDiscard: () async {
                          setState(() {
                            loadFuture = database.load();
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
        } else {
          return const CircularProgressIndicator();
        }
      }),
    );
  }
}
