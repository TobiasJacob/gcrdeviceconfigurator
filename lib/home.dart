import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/ui/axis_list.dart';

import 'data/profile.dart';
import 'ui/profile_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String activeProfile = "First Profile";
  String visibleAxis = "";

  @override
  Widget build(BuildContext context) {
    var profiles = {
      "First Profile": Profile("First Profile"),
      "Second Profile": Profile("Second Profile"),
      "Third Profile": Profile("Third Profile")
    };

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ProfileList(
            profiles: profiles,
            activeProfileId: activeProfile,
            onChanged: (activeProfile) {
              setState(() {
                this.activeProfile = activeProfile ?? "";
              });
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: AxisList(
              axes: profiles[activeProfile]?.axes ?? {},
              visibleAxis: visibleAxis,
              onChanged: (visibleAxis) {
                setState(() {
                  this.visibleAxis = visibleAxis!;
                });
              },
            )),
        Expanded(
          flex: 3,
          child: Container(color: Colors.blue),
        ),
      ],
    );
  }
}
