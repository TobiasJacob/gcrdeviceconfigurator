import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

import '../data/database.dart';

class AxisDetail extends StatelessWidget {
  final TextEditingController profileNameController;

  const AxisDetail({super.key, required this.profileNameController});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: 200,
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            controller: profileNameController,
            onChanged: database.updateProfileName,
          ),
          DropdownButton<Smoothing>(
            onChanged: database.setAxisSmoothing,
            value: database.visibleAxis.smoothing,
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
      const Expanded(
        child: Chart(),
      )
    ]);
  }
}
