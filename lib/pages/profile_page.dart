import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_profile.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/profile/chart/chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/app_settings.dart';
import '../data/profile.dart';
import 'profile/axis_list.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController profileNameController = TextEditingController();
  late Profile uneditedProfile;

  @override
  void initState() {
    super.initState();
  
    uneditedProfile = ref.read(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    
    final profile = ref.watch(profileProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);

    if (profileNameController.text != profile.name) {
      profileNameController.text = profile.name;
    }

    return WillPopScope(
        onWillPop: () => showExitPopup(context, ref),
        child: Scaffold(
            appBar: AppBar(
              title: Text(lang.editProfile(profile.name)),
              actions: [
                IconButton(
                    icon: const Icon(Icons.play_circle),
                    onPressed: () {
                      activateProfile(context, ref);
                    })
              ],
            ),
            body: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: profileNameController,
                                  onChanged: (value) {
                                    settingsNotifier.updateProfile(profile.updateName(value));
                                  },
                                )),
                            const Divider(),
                            Expanded(
                              child: AxisList(onSelect: (usage) {
                                setState(() {
                                  ref.watch(axisIdProvider.notifier).state = usage;
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
                )));
  }

  Future<bool> showExitPopup(BuildContext context, WidgetRef ref) async {
    final lang = Languages.of(context);
    final profile = ref.watch(profileProvider);
    final notif = ref.watch(settingsProvider.notifier);

    if (uneditedProfile == profile) {
      return true;
    }

    final confirmation = await showYesNoDialog(
        context, lang.saveProfile, lang.wantToSaveProfile);
    print(confirmation);

    if (confirmation == true) {
      notif.save();
    } else {
      notif.load();
    }
    return true;
  }
}
