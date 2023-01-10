/// This test is used to test the USB communication with the device.
import 'package:dartusbhid/enumerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
import 'package:gcrdeviceconfigurator/usb/config_serialize.dart';

//
void test() async {
    final database = Database();
    final appSettings = AppSettings();
    final buffer = serializeConfig(appSettings, database);

    print("Find devices");
    final devices = await enumerateDevices(22352, 1155);
    final device = await devices.first.open();
    var response = await device.readReport(null);
    print("Sent report");
    print(buffer.sublist(0, 64));
    await device.writeReport(buffer.sublist(0, 64));
    print("Waiting for response");
    while (response.isNotEmpty && response[0] != 0x02) {
      response = await device.readReport(0);
      print(response);
    }
    print(response);
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test();

  runApp(const MaterialApp());
}
