import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/ui/profile_tile.dart';

import '../data/database.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);
    final profileKeys = database.profiles.keys.toList();

    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: profileKeys.length,
        itemBuilder: (BuildContext context, int index) {
          return ProfileTile(
            profile: database.profiles[profileKeys[index]]!,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: database.createNewProfile,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.white,
                  onPressed: database.deleteProfileIfMoreThanOne,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
