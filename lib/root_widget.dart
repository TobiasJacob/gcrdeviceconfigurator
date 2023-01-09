import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';
import 'package:gcrdeviceconfigurator/main_data_provider.dart';

import 'apps/app.dart';
import 'apps/app_error.dart';
import 'package:provider/provider.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<StatefulWidget> createState() => RootWidgetState();
}

class RootWidgetState extends State<RootWidget> {
  late MainDataProvider mainDataProvier;

  @override
  void initState() {
    super.initState();
    mainDataProvier = MainDataProvider();
  }

  void resetToFactory() async {
    await MainDataProvider.resetToFactory();
    setState(() {
      mainDataProvier = MainDataProvider();
    });
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
            return AppError(
              errorMsg: snapshot.error.toString(),
              resetToFactory: resetToFactory,
            );
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
