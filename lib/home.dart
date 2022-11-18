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
  Map<String, Profile> profiles = {
    "First Profile": Profile("First Profile"),
    "Second Profile": Profile("Second Profile"),
    "Third Profile": Profile("Third Profile")
  };

  String activeProfile = "First Profile";
  String visibleAxis = "Gas";

  @override
  Widget build(BuildContext context) {
    var currentProfile = profiles[activeProfile]!;
    var currentAxis = currentProfile.axes[visibleAxis]!;

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
              axes: currentProfile.axes,
              visibleAxis: visibleAxis,
              onChanged: (visibleAxis) {
                setState(() {
                  this.visibleAxis = visibleAxis!;
                });
              },
            )),
        Expanded(
            flex: 3,
            child: AxisDetail(
                axis: currentAxis,
                updateDataPoint: (index, newDataPoint) {
                  setState(() {
                    currentAxis.dataPoints[index] = newDataPoint;
                  });
                },
                createDataPoint: (index) {
                  setState(() {
                    currentAxis.dataPoints.insert(
                        index + 1,
                        DataPoint(
                          (currentAxis.dataPoints[index].x +
                                  currentAxis.dataPoints[index + 1].x) /
                              2,
                          (currentAxis.dataPoints[index].y +
                                  currentAxis.dataPoints[index + 1].y) /
                              2,
                        ));
                  });
                },
                deleteDataPoint: ((index) {
                  setState(() {
                    currentAxis.dataPoints.removeAt(index);
                  });
                }))),
      ],
    );
  }
}
