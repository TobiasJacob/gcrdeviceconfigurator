
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_data_provider.dart';
import 'apps/app.dart';

class MainDataProviderWidget extends StatelessWidget {
  final Widget child;

  const MainDataProviderWidget({
    Key? key,
    required this.child,
    required this.mainDataProvier,
  }) : super(key: key);

  final MainDataProvider mainDataProvier;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => mainDataProvier.database),
        ChangeNotifierProvider(
            create: (context) => mainDataProvier.appSettings),
        ChangeNotifierProvider(
          create: (context) => mainDataProvier.usbStatus,
        )
      ],
      child: child,
    );
  }
}
