import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  String errorMsg;

  AppLoading({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    const title = "Get Closer Racing Configurator";
    return MaterialApp(
        title: title,
        home: Center(
            child: Column(children: [
          const CircularProgressIndicator(),
          Text(errorMsg)
        ])));
  }
}
