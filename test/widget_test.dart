// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';

import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:gcrdeviceconfigurator/pages/settings_page.dart';
import 'package:gcrdeviceconfigurator/root_widget.dart';

void main() {
  testWidgets('Create new profile UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    const app = RootWidget();
    await tester.pumpWidget(app);
    expect(find.byType(AppLoading), findsOneWidget);

    final RootWidgetState rootWidget = tester.state(find.byType(RootWidget));
    await rootWidget.mainDataProvier.loadFuture;

    await tester.pumpWidget(app);

    // Verify that our counter starts at 0.
    // expect(find.text('Default'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that a new profile has been created.
    expect(find.byType(SettingsPage), findsNothing);
    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
