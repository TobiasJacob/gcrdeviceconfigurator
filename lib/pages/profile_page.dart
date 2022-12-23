import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
import 'package:gcrdeviceconfigurator/pages/profile/chart/chart.dart';
import 'package:provider/provider.dart';

import '../data/app_settings.dart';
import '../data/profile.dart';
import 'profile/axis_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController profileNameController = TextEditingController();
  late Usage currentUsage;

  @override
  void initState() {
    super.initState();

    currentUsage = Usage.gas;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Profile.of(context);
    final axis = profile.axes[currentUsage]!;

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
                              child: AxisList(onSelect: (usage) {
                                setState(() {
                                  currentUsage = usage;
                                });
                              }),
                            )
                          ],
                        )),
                    const VerticalDivider(),
                    const Expanded(
                      flex: 3,
                      child: Chart(),
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
