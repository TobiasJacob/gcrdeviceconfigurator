import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
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
  final TextEditingController profileNameController = TextEditingController();
  late ControllerAxis axis;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<Profile>(context, listen: false);

    axis = profile.axes[0];
  }

  @override
  Widget build(BuildContext context) {
    final profile = Profile.of(context);

    if (profileNameController.text != profile.name) {
      profileNameController.text = profile.name;
    }

    return WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Edit ${profile.name}"),
            ),
            body: ChangeNotifierProvider.value(
                value: axis,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: profileNameController,
                                  onChanged: profile.updateName,
                                )),
                            const Divider(),
                            Expanded(
                              child: AxisList(onSelect: (axis) {
                                setState(() {
                                  this.axis = axis;
                                });
                              }),
                            )
                          ],
                        )),
                    const VerticalDivider(),
                    const Expanded(
                      flex: 3,
                      child: AxisDetail(),
                    ),
                  ],
                ))));
  }

  Future<bool> showExitPopup(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    if (!database.thisOrDependencyEdited()) {
      return true;
    }
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to save the profile?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  database.load();
                  return Navigator.of(context).pop(true);
                },
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  database.save();
                  return Navigator.of(context).pop(true);
                },
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
