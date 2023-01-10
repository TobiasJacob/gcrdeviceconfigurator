/// This test is used to test the USB communication with the device.
import 'dart:math';

import 'package:dartusbhid/enumerate.dart';
import 'package:flutter/foundation.dart';
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
    print("Full config has length");
    print(buffer.length); // 4 * (1 + 20 * 2 * 2) = 324
    assert(buffer.length == 324);

    // Open device
    print("Find devices");
    final devices = await enumerateDevices(22352, 1155);
    final device = await devices.first.open();
    var response = await device.readReport(null);

    // Check ping
    var commandWrite = WriteBuffer();
    commandWrite.putUint8(0x02); // Report ID (Send command)
    commandWrite.putUint8(0x00); // Ping Command
    commandWrite.putUint8List(Uint8List.fromList(List.filled(62, 0xDE))); // Fill with zeros (padding)
    var commandBytes = commandWrite.done();
    var command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);

    print("Sent ping");
    print(command);
    await device.writeReport(command);
    print("Waiting for pong");
    while (response.isNotEmpty && response[0] != 0x03) {
      response = await device.readReport(10);
      print(response);
    }

    // Send config
    print("Now commanding example config");
    commandWrite = WriteBuffer();
    commandWrite.putUint8(0x02); // Report ID (Send command)
    commandWrite.putUint8(0x03); // Send config command
    commandWrite.putUint8List(buffer.sublist(0, 62)); // Fill with random data
    commandBytes = commandWrite.done();
    command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
    await device.writeReport(command);

    print("Now sending an example configuration");
    for (var i = 0; i < buffer.length; i += 63) {
      commandWrite = WriteBuffer();
      commandWrite.putUint8(0x03); // Report ID (Send data)
      commandWrite.putUint8List(buffer.sublist(i, min(buffer.length, i + 63))); // Fill with random data
      commandWrite.putUint8List(Uint8List.fromList(List.filled(63 - min(buffer.length - i, 63), 0))); // Fill with zeros (padding)
      commandBytes = commandWrite.done();
      command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
      await device.writeReport(command);
      print(command);
    }

    print("Now commanding to receive an example configuration");
    commandWrite = WriteBuffer();
    commandWrite.putUint8(0x02); // Report ID (Send command)
    commandWrite.putUint8(0x02); // Send config command
    commandWrite.putUint8List(buffer.sublist(0, 62)); // Fill with random data
    commandBytes = commandWrite.done();
    command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
    await device.writeReport(command);
    print("Now should receive example configuration");
    for (var i = 0; i < 26; i++) {
      response = await device.readReport(null);
      print(response);
    }
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test();

  runApp(const MaterialApp());
}
