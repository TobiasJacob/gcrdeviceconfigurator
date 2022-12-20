import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/home.dart';
import 'package:dartusbhid/enumerate.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Database database;
  late Future loadFuture;
  late Random random;
  late Timer updateAxisValues;

  @override
  void initState() {
    super.initState();
    database = Database();
    loadFuture = database.load();
    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        database.updateCurrentAxisValue();
      });
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
      locale:
          Locale(database.settings.languageCode, database.settings.countryCode),
      home: FutureBuilder(
          future: loadFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return ChangeNotifierProvider(
                  create: (context) => Database(),
                  child: HomePage(
                    title: title,
                    database: database,
                    updateLanguage: () {
                      setState(() {});
                    },
                  ));
            } else {
              return const CircularProgressIndicator();
            }
          })),
      supportedLocales: const [Locale('en', 'EN'), Locale('de', 'DE')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
