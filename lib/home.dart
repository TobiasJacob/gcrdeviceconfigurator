import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/ui/axis_detail.dart';
import 'package:gcrdeviceconfigurator/ui/axis_list.dart';
import 'package:gcrdeviceconfigurator/ui/save_buttons.dart';

import 'data/database.dart';
import 'ui/profile_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController profileNameController = TextEditingController();

  bool edited = false;

  @override
  void initState() {
    super.initState();
    profileNameController.text = "Asdf";
  }

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

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
              : const ProfileList(),
        ),
        const VerticalDivider(),
        const Expanded(flex: 1, child: AxisList()),
        const VerticalDivider(),
        Expanded(
          flex: 3,
          child: AxisDetail(
            profileNameController: profileNameController,
          ),
        ),
      ],
    );
  }
}
