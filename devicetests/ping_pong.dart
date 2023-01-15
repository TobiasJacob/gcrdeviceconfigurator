/// This test is used to test the USB communication with the device.
/// Run with `flutter run -t devicetests\ping_pong.dart`
import 'dart:math';

import 'package:dartusbhid/enumerate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
import 'package:gcrdeviceconfigurator/usb/config_serialize.dart';
import 'package:gcrdeviceconfigurator/usb/usb_hid_device.dart';

//
void test() async {
    final database = Database();
    final appSettings = AppSettings();
    final buffer = serializeConfig(appSettings, database);
    debugPrint("Full config has length ${buffer.length}"); // 4 * (1 + 2 * 2 + 20 * 2 * 2) = 340
    assert(buffer.length == 340);

    final device = GcrUsbHidDevice();
    await device.open();

    // Create Uint8List with 0xDEADBEEF and length 62
    final data = Uint8List(62);
    data[0] = 0xDE;
    data[1] = 0xAD;
    data[2] = 0xBE;
    data[3] = 0xEF;
    data[4] = 0x00;
    data[5] = 0x01;
    data[6] = 0x02;
    data[7] = 0x03;

    // Send data to device
    debugPrint("Send ping...");
    await device.sendPing(data);

    // Receive raw adc values
    debugPrint("Receiving raw adc values...");
    final adcValues = await device.receiveRawADCValues();
    debugPrint("Received raw adc values: $adcValues");

    // Send config to device
    debugPrint("Send config...");
    await device.sendSerializedConfig(buffer);

    // Receive config from device
    debugPrint("Receive config...");
    final receivedConfig = await device.readSerializedConfig();

    assert (receivedConfig.length == buffer.length);
    for (int i = 0; i < receivedConfig.length; i++) {
      assert(receivedConfig[i] == buffer[i]);
    }

    await device.close();
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test();

  runApp(const MaterialApp());
}
