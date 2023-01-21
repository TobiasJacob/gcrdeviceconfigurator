
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/apps/app_data.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home/profile_list.dart';
import 'package:gcrdeviceconfigurator/pages/home/profile_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('Profile list shows profiles', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
  
    final settings = container.read(settingsProvider);
    final notif = container.read(settingsProvider.notifier);
  
    final widget = ProviderScope(
      parent: container,
      child: const AppData(home: Scaffold(body: ProfileList())));

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.byType(ProfileTile), findsNWidgets(1));
    notif.update(settings.createNewProfile("Testname").item1);

    await tester.pumpWidget(widget);
    expect(find.byType(ProfileTile), findsNWidgets(2));
    expect(find.text("Testname"), findsOneWidget);
  });
}
