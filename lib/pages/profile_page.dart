import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:provider/provider.dart';

import '../data/profile.dart';
import '../ui/axis_detail.dart';
import '../ui/axis_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ControllerAxis axis;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<Profile>(context, listen: false);

    axis = profile.axes.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurator"),
        ),
        body: ChangeNotifierProvider.value(
            value: axis,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: AxisList(onSelect: (axis) {
                      setState(() {
                        this.axis = axis;
                      });
                    })),
                const VerticalDivider(),
                const Expanded(
                  flex: 3,
                  child: AxisDetail(),
                ),
              ],
            )));
  }
}
