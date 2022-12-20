import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/ui/chart.dart';

import '../data/database.dart';

class AxisDetail extends StatefulWidget {
  const AxisDetail({super.key});

  @override
  State<AxisDetail> createState() => _AxisDetailState();
}

class _AxisDetailState extends State<AxisDetail> {
  final TextEditingController profileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    if (profileNameController.text != database.visibleProfile.name) {
      profileNameController.text = database.visibleProfile.name;
    }

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
