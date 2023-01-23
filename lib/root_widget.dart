import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/pages/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'apps/app_data.dart';
import 'apps/app_error.dart';


class RootWidget extends ConsumerStatefulWidget {
  const RootWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => RootWidgetState();
}

class RootWidgetState extends ConsumerState<RootWidget> {
  late Future loadFuture;

  @override
  void initState() {
    super.initState();
    loadFuture = ref.read(settingsProvider.notifier).load();
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
              onResetToFactory: () async {
                await ref.read(settingsProvider.notifier).resetToFactory();
                setState(() {
                  loadFuture = ref.read(settingsProvider.notifier).load();
                });
              },
            );
          }
          return const AppData(home: HomePage());
        });
  }
}
