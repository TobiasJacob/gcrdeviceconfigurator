import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../pages/home_page.dart';
import '../i18n/app_localization_delegate.dart';

class MyApp extends StatelessWidget {
  Widget home;

  MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    const title = "Pedal Config";
    final AppSettings languageSettings = AppSettings.of(context);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: title,
      debugShowCheckedModeBanner: true,
      locale:
          Locale(languageSettings.languageCode, languageSettings.countryCode),
      home: home,
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
