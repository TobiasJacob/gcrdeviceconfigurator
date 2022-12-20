import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "Get Closer Racing Configurator";
    return MaterialApp(
        title: title,
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: CircularProgressIndicator(),
                ))));
  }
}
