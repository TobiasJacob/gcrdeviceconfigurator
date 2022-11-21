import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

class AxisDetail extends StatelessWidget {
  final TextEditingController profileNameController;
  final Profile profile;
  final ControllerAxis axis;
  final Function(ControllerAxis axis) updateAxis;
  final Function(Profile profile) updateProfile;

  const AxisDetail(
      {super.key,
      required this.profile,
      required this.axis,
      required this.updateAxis,
      required this.updateProfile,
      required this.profileNameController});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: 200,
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            controller: profileNameController,
            onChanged: (value) {
              profile.name = value;
              updateProfile(profile);
            },
          ),
          DropdownButton(
            onChanged: (value) {
              axis.smoothing = value ?? Smoothing.normal;
              updateAxis(axis);
            },
            value: axis.smoothing,
            items: const [
              DropdownMenuItem(
                value: Smoothing.highAccuracy,
                child: Text("Genauer"),
              ),
              DropdownMenuItem(
                value: Smoothing.normal,
                child: Text("Ausgewogen"),
              ),
              DropdownMenuItem(
                value: Smoothing.highSpeed,
                child: Text("Schneller"),
              )
            ],
          )
        ]),
      ),
      Expanded(
        child: Chart(
          axis: axis,
          updateAxis: updateAxis,
        ),
      )
    ]);
  }
}
