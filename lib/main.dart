import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/home.dart';
import 'package:dartusbhid/enumerate.dart';

import 'i18n/app_localization_delegate.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale.fromSubtags(languageCode: "en");

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = "Get Closer Racing Configurator";

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Multi Language',
      debugShowCheckedModeBanner: true,
      locale: _locale,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: const Home()),
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('hi', '')
      ],
      localizationsDelegates: const [AppLocalizationsDelegate()],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
