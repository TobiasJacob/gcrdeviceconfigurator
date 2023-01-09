import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';
import 'package:gcrdeviceconfigurator/main_data_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home_page.dart';

import 'apps/app.dart';
import 'apps/app_error.dart';
import 'package:provider/provider.dart';

import 'main_data_provider_widget.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<StatefulWidget> createState() => RootWidgetState();
}

class RootWidgetState extends State<RootWidget> {
  late MainDataProvider mainDataProvier;
  late Future loadFuture;
  late Timer updateAxisValues;

  @override
  void initState() {
    super.initState();
    mainDataProvier = MainDataProvider();
    loadFuture = mainDataProvier.loadData();

    
    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), mainDataProvier.usbStatus.updateValues);
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
        future: loadFuture,
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
          return MainDataProviderWidget(mainDataProvier: mainDataProvier, child: MyApp(home: const HomePage()),);
        });
  }
}
