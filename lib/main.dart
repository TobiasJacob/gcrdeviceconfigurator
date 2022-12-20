import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/home.dart';
import 'package:dartusbhid/enumerate.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';
import 'data/database.dart';
import 'home_page.dart';
import 'i18n/app_localization_delegate.dart';
import 'package:provider/provider.dart';

void test() async {
  return;
  final devices = await enumerateDevices(0, 0);
  print(devices.length);
  for (final device in devices) {
    // Print device information like product name, vendor, etc.
    print(device);
  }

  final openDevice = await devices[0].open();
  // Read data without timeout (timeout: null)
  print("Waiting for first hid report");
  final receivedData = await openDevice.readReport(null);
  print(receivedData);
  await openDevice.close();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test();

  runApp(const MyApp());
}
