import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/home.dart';
import 'package:dartusbhid/enumerate.dart';

void test() async {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "Get Closer Racing Configurator";

    return MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text(title),
            ),
            body: const Home()));
  }
}
