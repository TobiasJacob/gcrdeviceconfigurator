import 'dart:math';

import 'package:flutter/material.dart';
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
    "kdjeks": Profile("First Profile"),
    "dfse": Profile("Second Profile"),
    "skxi": Profile("Third Profile")
  };

  String activeProfileId = "kdjeks";
  String visibleProfileId = "kdjeks";
  String visibleAxisId = "dkixm";

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
          ),
        ),
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
        Expanded(
            flex: 3,
            child: AxisDetail(
                axis: currentAxis,
                updateDataPoint: (index, newDataPoint) {
                  setState(() {
                    var x = newDataPoint.x;
                    var y = newDataPoint.y;
                    if (index > 0) {
                      x = max(x, currentAxis.dataPoints[index - 1].x);
                    } else {
                      x = max(x, 0);
                    }
                    if (index < currentAxis.dataPoints.length - 1) {
                      x = min(x, currentAxis.dataPoints[index + 1].x);
                    } else {
                      x = min(x, 1);
                    }
                    y = max(y, 0);
                    y = min(y, 1);
                    currentAxis.dataPoints[index] = DataPoint(x, y);
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