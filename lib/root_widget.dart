import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/main.dart';
import 'package:gcrdeviceconfigurator/main_data_provider.dart';

import 'apps/app.dart';
import 'apps/app_error.dart';
import 'data/database.dart';
import 'package:provider/provider.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<StatefulWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late MainDataProvider mainDataProvier;

  @override
  void initState() {
    super.initState();
    mainDataProvier = MainDataProvider();
    mainDataProvier.updateUserInterface = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mainDataProvier.loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppLoading();
          }
          if (snapshot.hasError) {
            return AppError(errorMsg: snapshot.error.toString());
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => mainDataProvier.database),
              ChangeNotifierProvider(
                  create: (context) => mainDataProvier.languageSettings),
              ChangeNotifierProvider(
                create: (context) => mainDataProvier.usbStatus,
              )
            ],
            child: const MyApp(),
          );
        });
  }
}
